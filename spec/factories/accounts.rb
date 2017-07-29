# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#

FactoryGirl.define do
  factory :account do
    name 'MyString'
    association :owner, factory: :user

    trait :invalid do
      name nil
    end
  end
end
