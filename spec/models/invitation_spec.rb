# frozen_string_literal: true

# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  token      :string           not null
#
# Indexes
#
#  index_invitations_on_account_id  (account_id)
#  index_invitations_on_token       (token)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it 'has a valid factory' do
    expect(build(:invitation)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:invitation) { build(:invitation) }

  describe 'ActiveModel validations' do
    it { expect(invitation).to validate_presence_of(:email) }
  end

  describe 'Associations' do
    it { expect(invitation).to belong_to(:account) }
  end

  describe 'Database columns' do
    it { expect(invitation).to have_db_index(:account_id) }
  end

  it 'generates a unique token' do
    invitation.save
    expect(invitation.token).to be_present
  end
end
