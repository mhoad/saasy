# frozen_string_literal: true

# Naturally many of the various resources which are scoped to accounts all need
# to be appropriately locked down in order to ensure that unauthorized users
# can not access them. This is where those concerns live
module AccountAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :authorize_user!
    before_action :subscription_required!
    helper_method :current_account
    helper_method :owner?
  end

  def current_account
    @current_account ||= Account.find_by!(subdomain: request.subdomain)
  end

  def owner?
    current_account.owner == current_user
  end

  private

  def authorize_user!
    authenticate_user!
    unless current_account.owner == current_user ||
           current_account.users.exists?(current_user.id)
      flash[:notice] = 'You are not permitted to view that account.'
      redirect_to root_url(subdomain: nil)
    end
  end

  def authorize_owner!
    return if owner?
    flash[:notice] = 'Only an owner of an account can do that.'
    redirect_to root_url(subdomain: current_account.subdomain)
  end

  def subscription_required!
    return unless owner? && current_account.stripe_customer_id.blank?
    message = 'You must subscribe to a plan before you can use your account.'
    flash[:alert] = message
    redirect_to choose_plan_url
  end
end
