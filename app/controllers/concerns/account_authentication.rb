# frozen_string_literal: true

module AccountAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    helper_method :current_account
    helper_method :owner?
  end

  def current_account
    @current_account ||= Account.find_by!(subdomain: request.subdomain)
  end

  def owner?
    current_account.owner == current_user
  end
end
