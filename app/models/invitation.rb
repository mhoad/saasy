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

# Users with certain permissions are able to invite new users
# to their account using this feature.
class Invitation < ApplicationRecord
  belongs_to :account
  delegate :name, :subdomain, to: :account, prefix: true

  before_create :generate_token

  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/,
                                              message: 'only allows valid e-mail addresses' }

  # We want to use the invitation token instead of 'id' as the parameter
  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.hex(16)
  end
end
