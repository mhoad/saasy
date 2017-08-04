# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                 :integer          not null, primary key
#  name               :string(60)       not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :integer
#  subdomain          :string(60)       not null
#  stripe_customer_id :string
#  plan_id            :integer
#
# Indexes
#
#  index_accounts_on_plan_id    (plan_id)
#  index_accounts_on_subdomain  (subdomain) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#

FactoryGirl.define do
  factory :account do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }
    association :owner, factory: :user
    plan

    trait :invalid do
      name nil
    end
  end
end
