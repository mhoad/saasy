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
    visit root_url
    click_link 'Change Plan'
    click_link 'Cancel your subscription'
    within('.alert') do
      expect(page).to have_content('Your subscription has been cancelled.')
    end

    account.reload
    expect(account.stripe_subscription_id).to be_blank
    active_subscriptions = customer.subscriptions.all
    expect(active_subscriptions.data.blank?).to be true
  end

  scenario 'can be updated' do
    silver_plan = FactoryGirl.create(:plan, name: 'Silver', stripe_id: 'silver')

    visit root_url
    click_link 'Change Plan'
    click_button 'choose_silver'

    customer = Stripe::Customer.retrieve(account.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(account.stripe_subscription_id)
    expect(subscription.plan.id).to eq(silver_plan.stripe_id)

    account.reload
    expect(account.plan).to eq(silver_plan)

    within('.alert') do
      expect(page).to have_content('You have changed to the Silver plan')
    end
  end

  scenario 'is prompted to upgrade plan when over limit' do
    starter_plan = FactoryGirl.create(:plan, name: 'Starter', stripe_id: 'starter', projects_allowed: 1)
    silver_plan = FactoryGirl.create(:plan, name: 'Silver', stripe_id: 'silver', projects_allowed: 3)

    account.plan = starter_plan
    account.projects << FactoryGirl.create(:project)
    account.save

    visit root_url
    click_link 'Add Project'

    within('.alert') do
      message = "You have reached your plan's limit. You need to upgrade to add more projects."
      expect(page).to have_content(message)
    end

    click_button 'choose_silver'

    within('.alert') do
      expect(page).to have_content('You have changed to the Silver plan.')
    end

    expect(page.current_url).to eq(new_project_url)
  end
end
