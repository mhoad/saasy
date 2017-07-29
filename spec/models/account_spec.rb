# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string(60)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#  subdomain  :string(60)       not null
#
# Indexes
#
#  index_accounts_on_subdomain  (subdomain) UNIQUE
#

require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'has a valid factory' do
    expect(build(:account)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:account) { build(:account) }

  describe 'ActiveModel validations' do
    it { expect(account).to validate_presence_of(:name) }
    it { expect(account).to validate_length_of(:name).is_at_least(2).is_at_most(60) }
    it { expect(account).to validate_presence_of(:subdomain) }
    it { expect(account).to validate_length_of(:subdomain).is_at_least(2).is_at_most(60) }
    it { expect(account).to validate_uniqueness_of(:subdomain).case_insensitive }
  end

  describe 'Associations' do
    it { expect(account).to belong_to(:owner) }
    # it { expect(account).to have_many(:invitations) }
    # it { expect(account).to have_many(:widgets) }
  end

  describe 'Database columns' do
    it { expect(account).to have_db_index(:subdomain).unique(:true) }
  end
end
