# frozen_string_literal: true

# == Schema Information
#
# Table name: subscription_events
#
#  id         :integer          not null, primary key
#  account_id :integer
#  type       :string
#  stripe_id  :string
#  data       :jsonb
#  created_at :datetime
#
# Indexes
#
#  index_subscription_events_on_account_id  (account_id)
#  index_subscription_events_on_stripe_id   (stripe_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class SubscriptionEvent < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :account
  # We want to ensure that we don't process or store events more than once
  validates :stripe_id, presence: true, uniqueness: { case_sensitive: false }

  def self.process_webhook(event)
    # Start by finding which Account corresponds with the Stripe customer ID
    account = Account.find_by!(stripe_customer_id: event[:data][:object][:customer])
    # Log the event in the database and associate it with the relevant account
    account.subscription_events.create(
      stripe_id: event[:id], # Unique identifier produced by Stripe on per event basis
      type: event[:type],    # What kind of event e.g. customer.subscription.deleted
      data: event[:data]     # The JSON blob containing all the info about the event
    )
    # Depending on what kind of event it is we may need to do additional stuff to it
    additional_processing(account, event)
  end

  # Handle any additional processing depending on what the event type was
  def self.additional_processing(account, event)
    case event[:type]
    when 'customer.subscription.updated'
      handle_subscription_updated_event(account, event[:data])
    end
  end

  def self.handle_subscription_updated_event(account, data)
    account.stripe_subscription_status = data[:object][:status]
    account.save
  end
end
