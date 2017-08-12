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
      return if exceed_limitations?(plan)

      update_customer_plan(plan)

      flash[:notice] = "You have changed to the #{plan.name} plan."

      # If the user was trying to do another action such as adding a new
      # project when they were sent here we should return them to that after
      # they have successfully upgraded. Otherwise if they are just signing
      # up for a new account we should send them to the root_url instead.
      return_to = session.delete(:return_to)
      redirect_to return_to || root_url
    end

    private

    # Create a new Stripe subscription for a given account
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

    # Update the current accounts subscription to whatever plan is specified
    def update_customer_plan(plan)
      customer = Stripe::Customer.retrieve(current_account.stripe_customer_id)
      subscription = customer.subscriptions.retrieve(current_account.stripe_subscription_id)
      subscription.plan = plan.stripe_id
      subscription.save

      current_account.update_column(:plan_id, plan.id)
    end

    # Check if an account is over the assigned limit for any of the
    # resources associated with a given plan
    def exceed_limitations?(plan)
      if current_account.over_limit_for?(plan)
        message = "You cannot switch to that plan. Your account is over that plan's limit."
        flash[:alert] = message
        redirect_to choose_plan_path
      else
        false
      end
    end
  end
end
