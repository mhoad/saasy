# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Plans', type: :feature do
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
  let(:account) { FactoryGirl.create(:account) }

  before do
    subscription = customer.subscriptions.create(plan: 'starter')
    account.stripe_customer_id = customer.id
    account.stripe_subscription_id = subscription.id
    account.save
    set_subdomain(account.subdomain)
    login_as(account.owner)
  end

  scenario 'prompt you to upgrade your plan when over the limit' do
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
    account.reload
    expect(account.plan).to eq(silver_plan)
  end

  scenario 'do not allow you to select plans that are not suitable' do
    FactoryGirl.create(:plan, name: 'Starter', stripe_id: 'starter', projects_allowed: 1)
    silver_plan = FactoryGirl.create(:plan, name: 'Silver', stripe_id: 'silver', projects_allowed: 3)

    account.plan = silver_plan
    account.projects << FactoryGirl.create_list(:project, 2)
    account.save

    visit choose_plan_url
    expect(page).to have_button('choose_starter', disabled: true)
  end
end
