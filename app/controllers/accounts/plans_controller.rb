# frozen_string_literal: true

module Accounts
  class PlansController < ApplicationController
    include AccountAuthentication

    def choose
      @plans = Plan.order(:amount_cents)
    end

    def chosen
      current_account.plan_id = params[:account][:plan]
      current_account.save
      flash[:notice] = 'Your account has been created.'
      redirect_to root_url(subdomain: current_account.subdomain)
    end
  end
end
