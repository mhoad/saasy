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

FactoryGirl.define do
  factory :subscription_event do
    account
    stripe_id 'stripe_event_001'
    type 'customer.subscription.deleted'
    data 'object': { 'id': 'sub_001', 'customer': 'cus_001' }
  end
end
