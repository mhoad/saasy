# frozen_string_literal: true

module Accounts
  class PlansController < ApplicationController
    include AccountAuthentication

    def choose
      @plans = Plan.order(:amount_cents)
    end

    def chosen
      create_stripe_subscription(current_account)
      flash[:notice] = 'Your account has been created.'
      redirect_to root_url(subdomain: current_account.subdomain)
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
