# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Accounts', type: :feature do
  let!(:plan) { FactoryGirl.create(:plan, name: 'Starter', stripe_id: 'starter') }

  scenario 'creating an account', js: true do
    set_default_host
    visit root_path
    click_link 'Create an account'
    sign_up(name: 'test', subdomain: 'test', email: 'test@example.com', password: 'password')
    perform_enqueued_jobs do
      click_button 'Next'
    end

    account = Account.last
    expect(account.stripe_customer_id).to be_present
    expect(page.current_url).to eq(choose_plan_url(subdomain: account.subdomain))
    choose 'Starter'
    click_button 'Pay'

    within_frame('stripe_checkout_app') do
      fill_in 'Email', with: 'test@example.com'
      card_number = find_field('Card number')
      card_number.send_keys('4242 4242 4242 4242 4242')

      expiry = 1.month.from_now
      exp_input = find_field('Expiry')
      exp_input.send_keys(expiry.strftime('%m'))
      sleep(0.25)
      exp_input.send_keys(expiry.strftime('%y'))

      csc_input = find_field('CVC')
      csc_input.send_keys('424')
      submit_button = find('.Button')
      submit_button.click
    end

    within('.alert') do
      success_message = 'Your account has been created.'
      expect(page).to have_content(success_message)
    end

    account.reload
    expect(account.plan).to eq(plan)

    expect(page).to have_content('Signed in as test@example.com')
    expect(page.current_url).to eq(root_url(subdomain: account.subdomain))

    open_email('test@example.com')
    expect(current_email).to have_content('Welcome')
  end

  scenario 'ensure subdomain uniqueness' do
    owner = User.create!(email: 'owner@example.com', password: 'password')
    FactoryGirl.create(:account, subdomain: 'test', name: 'test', owner: owner)

    visit root_path
    click_link 'Create an account'
    sign_up(name: 'test', subdomain: 'test', email: 'user@example.com', password: 'password')
    click_button 'Next'

    expect(page.current_url).to eq('http://lvh.me/accounts')
    expect(page).to have_content('Sorry, your account could not be created.')
    expect(page).to have_content('Subdomain has already been taken')
  end

  def sign_up(name:, subdomain:, email:, password:)
    fill_in 'Name', with: name
    fill_in 'Subdomain', with: subdomain
    fill_in 'Email', with: email
    fill_in 'Password', with: password, exact: true
    fill_in 'Password confirmation', with: password
  end
end
