# frozen_string_literal: true

class AccountsController < ApplicationController
  def new
    @account = Account.new
    @account.build_owner
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      create_stripe_customer(@account)
      sign_in(@account.owner)
      redirect_to choose_plan_url(subdomain: @account.subdomain)
    else
      flash.now[:alert] = 'Sorry, your account could not be created.'
      render :new
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :subdomain,
                                    owner_attributes: %i[
                                      email password password_confirmation
                                    ])
  end

  def create_stripe_customer(account)
    customer = Stripe::Customer.create(
      description: account.subdomain,
      email: account.owner.email
    )
    account.update_column(:stripe_customer_id, customer.id)
  end
end
