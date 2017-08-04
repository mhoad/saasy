# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  name              :string
#  amount_cents      :integer          default(0), not null
#  amount_currency   :string           default("USD"), not null
#  stripe_id         :string           not null
#  live              :boolean          not null
#  billing_cycle     :string           not null
#  trial_period_days :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_plans_on_stripe_id  (stripe_id)
#

require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'has a valid factory' do
    expect(build(:plan)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:plan) { build(:plan) }

  describe 'ActiveModel validations' do
    it { expect(plan).to validate_presence_of(:amount_cents) }
    it { expect(plan).to validate_presence_of(:stripe_id) }
    it { expect(plan).to validate_presence_of(:billing_cycle) }
  end

  describe 'Database columns' do
    it { expect(plan).to have_db_index(:stripe_id) }
  end
end
