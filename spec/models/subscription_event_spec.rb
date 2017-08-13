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

require 'rails_helper'

RSpec.describe SubscriptionEvent, type: :model do
  it 'has a valid factory' do
    expect(build(:subscription_event)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:subscription_event) { build(:subscription_event) }

  describe 'ActiveModel validations' do
    it { expect(subscription_event).to validate_presence_of(:stripe_id) }
    it { expect(subscription_event).to validate_uniqueness_of(:stripe_id).case_insensitive }
  end

  describe 'Associations' do
    it { expect(subscription_event).to belong_to(:account) }
  end

  describe 'Database columns' do
    it { expect(subscription_event).to have_db_index(:stripe_id) }
  end

  let!(:account) do
    FactoryGirl.create(:account,
                       stripe_subscription_id: 'sub_001',
                       stripe_customer_id: 'cus_001')
  end

  describe 'Functionality' do
    subscription_deleted_event = {
      id: 'stripe_event_id_001',
      type: 'customer.subscription.deleted',
      data: {
        'object': {
          'id': 'sub_001',
          'customer': 'cus_001'
        }
      }
    }

    it 'stores a customer.subscription.deleted event' do
      SubscriptionEvent.process_webhook(subscription_deleted_event)
      expect(account.subscription_events.count).to eq(1)

      event = account.subscription_events.first
      expect(event.type).to eq('customer.subscription.deleted')
    end

    it 'does not allow for duplicate events to be stored' do
      SubscriptionEvent.process_webhook(subscription_deleted_event)
      expect(account.subscription_events.count).to eq(1)

      SubscriptionEvent.process_webhook(subscription_deleted_event)
      expect(account.subscription_events.count).to eq(1)
    end
  end
end
