# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  account_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_memberships_on_account_id  (account_id)
#  index_memberships_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Membership, type: :model do
  it 'has a valid factory' do
    expect(build(:membership)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:membership) { build(:membership) }

  describe 'ActiveModel validations' do
    it { expect(membership).to validate_presence_of(:account) }
    it { expect(membership).to validate_presence_of(:user) }
  end

  describe 'Associations' do
    it { expect(membership).to belong_to(:account) }
    it { expect(membership).to belong_to(:user) }
  end

  describe 'Database columns' do
    it { expect(membership).to have_db_index(:account_id) }
    it { expect(membership).to have_db_index(:user_id) }
  end
end
