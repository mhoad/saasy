# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                         :integer          not null, primary key
#  name                       :string(60)       not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  owner_id                   :integer
#  subdomain                  :string(60)       not null
#  stripe_customer_id         :string
#  plan_id                    :integer
#  stripe_subscription_id     :string
#  stripe_subscription_status :string
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

class Account < ApplicationRecord
  # Make sure the subdomain doesnt have any weird spaces or anything
  # which could pose an issue when creating a URL or checking
  # for uniqueness.
  before_validation do
    self.subdomain = subdomain.delete(' ') if attribute_present?('subdomain')
  end

  validates :name, presence: true, length: { minimum: 2, maximum: 60 }
  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 60 }
  validates_format_of :subdomain, with: /\A[a-zA-Z]+\z/, message: 'only letters are valid subdomains'
  validates :subdomain, exclusion: {
    in: %w[www admin about beta billing blog cdn chat cpanel download email
           search smtp pop mail mobile my news payment porn purchase affiliate],
    message: '%<value>% is not a valid subdomain.'
  }

  has_many :projects
  has_many :invitations
  has_many :memberships
  has_many :users, through: :memberships
  has_many :subscription_events
  belongs_to :plan, optional: true

  belongs_to :owner, class_name: 'User'
  accepts_nested_attributes_for :owner

  def subscribed?
    stripe_subscription_id.present?
  end

  # Check if an account is over the limit for any of the resources
  # associated with a given plan
  def over_limit_for?(plan)
    return true if projects.count > plan.projects_allowed
    false
  end
end
