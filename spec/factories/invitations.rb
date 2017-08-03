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

FactoryGirl.define do
  factory :invitation do
    email { Faker::Internet.email }
    account
  end
end
