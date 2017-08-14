# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin account dashboard', type: :feature do
  let!(:starter_plan) { FactoryGirl.create(:plan, name: 'Starter', amount_cents: 995) }
  let!(:account) { FactoryGirl.create(:account, plan: starter_plan) }
  let!(:subscription_event) do
    account.subscription_events.create(
      type: 'customer.subscription.created',
      stripe_id: 'abc123'
    )
  end

  before do
    set_default_host
  end

  context 'as an admin' do
    let!(:admin) { FactoryGirl.create(:user, admin: true) }

    before do
      login_as(admin)
    end

    scenario 'it can find an account by its subdomain' do
      visit admin_root_path
      expect(page).to have_content('Find account by subdomain')
      fill_in 'Subdomain', with: account.subdomain
      click_button 'Search'

      expect(page.current_url).to eq(admin_account_url(account))
      expect(page).to have_content(account.name)
      expect(page).to have_content("Plan: #{starter_plan.name}")

      within('#subscription_events') do
        expect(page).to have_content('customer.subscription.created')
      end
    end

    scenario 'looks at unpaid accounts' do
      unpaid_account = FactoryGirl.create(
        :account,
        stripe_subscription_status: 'unpaid',
        plan: starter_plan
      )

      visit admin_root_path
      click_link 'Unpaid accounts'
      expect(page).not_to have_content(account.name)

      click_link unpaid_account.name
      expect(page.current_url).to eq(admin_account_url(unpaid_account))
    end
  end

  context 'as a user' do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      login_as(user)
    end

    scenario 'is unauthorized' do
      visit admin_root_path
      expect(page.current_url).to eq(root_url)
      within('.alert') do
        expect(page).to have_content('You are not permitted to access that.')
      end
    end
  end
end
