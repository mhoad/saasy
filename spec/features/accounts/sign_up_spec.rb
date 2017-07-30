# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Accounts', type: :feature do
  scenario 'creating an account' do
    visit root_path
    click_link 'Create an account'
    sign_up(name: 'test', subdomain: 'test', email: 'test@example.com', password: 'password')
    perform_enqueued_jobs do
      click_button 'Create Account'
    end

    within('.alert') do
      success_message = 'Your account has been created.'
      expect(page).to have_content(success_message)
    end

    expect(page).to have_content('Signed in as test@example.com')
    expect(page.current_url).to eq('http://test.lvh.me/')

    open_email('test@example.com')
    expect(current_email).to have_content('Welcome')
  end

  scenario 'ensure subdomain uniqueness' do
    owner = User.create!(email: 'owner@example.com', password: 'password')
    Account.create!(subdomain: 'test', name: 'test', owner: owner)

    visit root_path
    click_link 'Create an account'
    sign_up(name: 'test', subdomain: 'test', email: 'user@example.com', password: 'password')
    click_button 'Create Account'

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
