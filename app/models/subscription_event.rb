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
  validates :stripe_id, presence: true, uniqueness: { case_sensitive: false }

  def self.process_webhook(event)
    account = Account.find_by!(stripe_customer_id: event[:data][:object][:customer])
    account.subscription_events.create(
      stripe_id: event[:id],
      type: event[:type],
      data: event[:data]
    )
  end
end
