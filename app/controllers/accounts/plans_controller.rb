# frozen_string_literal: true

module Accounts
  # Each account will have a subscription to one of the 'plans' on offer.
  # These plans are created in Stripe and stored locally through the
  # plan fetcher. Users can select a plan, cancel an existing plan or
  # switch between various plan options which will then need to be
  # reflected both locally and in Stripe itself
  class PlansController < ApplicationController
    include AccountAuthentication
    skip_before_action :subscription_required!

    def choose
      @plans = Plan.order(:amount_cents)
    end

    def chosen
      create_stripe_subscription(current_account)
      flash[:notice] = 'Your account has been created.'
      redirect_to root_url(subdomain: current_account.subdomain)
    end

    def cancel
      customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
      subscription = customer.subscriptions.retrieve(current_account.stripe_subscription_id).delete

      return unless subscription.status == 'canceled'

      current_account.update_column(:stripe_subscription_id, nil)
      flash[:notice] = 'Your subscription has been cancelled.'
      redirect_to root_url(subdomain: nil)
    end

    def switch
      plan = Plan.find(params[:plan_id])
      customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
      subscription = customer.subscriptions.retrieve(current_account.stripe_subscription_id)
      subscription.plan = plan.stripe_id
      subscription.save

      current_account.update_column(:plan_id, plan.id)

      flash[:notice] = "You have changed to the #{plan.name} plan."
      redirect_to root_url
    end

    private

    def create_stripe_subscription(account)
      customer = Stripe::Customer.retrieve(account.stripe_customer_id)
      plan = Plan.find(params[:account][:plan])
      subscription = customer.subscriptions.create(
        plan: plan.stripe_id,
        source: params[:token]
      )

      account.plan = plan
      account.stripe_subscription_id = subscription.id
      account.save
    end
  end
end
