# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
# Indexes
#
#  index_projects_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:project) { build(:project) }

  describe 'ActiveModel validations' do
    it { expect(project).to validate_presence_of(:name) }
    it { expect(project).to validate_length_of(:name).is_at_least(2).is_at_most(240) }
    it { expect(project).to_not validate_presence_of(:description) }
    it { expect(project).to validate_length_of(:description).is_at_least(2).is_at_most(240) }
  end

  describe 'Associations' do
    it { expect(project).to belong_to(:account) }
  end

  describe 'Database columns' do
    it { expect(project).to have_db_index(:account_id) }
  end
end
