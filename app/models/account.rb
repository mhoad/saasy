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

class Account < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 60 }
  belongs_to :owner, class_name: 'User'
  accepts_nested_attributes_for :owner
end
