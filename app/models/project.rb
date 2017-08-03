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

# Projects are the first thing that a user would create in their new account
# they are used for various things like a company may want to run tests on
# both their website and their mobile app so they would create
# separate projects for each of those instances.
class Project < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 240 }
  validates :description, length: { minimum: 2, maximum: 240 }
  belongs_to :account
end
