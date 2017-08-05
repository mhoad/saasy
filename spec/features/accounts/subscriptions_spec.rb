# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Subscriptions', type: :feature do
  let(:customer) do
    Stripe::Customer.create(
      source: {
        object: 'card',
        number: '4242424242424242',
        exp_month: Time.now.month,
        exp_year: Time.now.year + 1,
        cvc: '123'
      }
    )
  end

  let(:plan) { Plan.create(name: 'starter', stripe_id: 'starter') }
  let(:account) { FactoryGirl.create(:account, :invalid) }

  before do
    subscription = customer.subscriptions.create(plan: 'starter')
    account.stripe_customer_id = customer.id
    account.stripe_subscription_id = subscription.id
    account.save

    set_subdomain(account.subdomain)
    login_as(account.owner)
  end

  scenario 'can be cancelled' do
    old_subscription_id = account.stripe_subscription_id

    visit root_url
    click_link 'Change Plan'
    click_link 'Cancel your subscription'
    within('.alert') do
      expect(page).to have_content('Your subscription has been cancelled.')
    end

    account.reload
    expect(account.stripe_subscription_id).to be_blank
    active_subscriptions = customer.subscriptions.all
    # byebug
    expect(active_subscriptions.data.blank?).to be true
  end
end
