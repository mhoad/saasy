# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Accounts', type: :feature do
  scenario 'creating an account' do
    visit root_path

    click_link 'Create an account'
    fill_in 'Name', with: 'test'
    fill_in 'Subdomain', with: 'test'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password', exact: true
    fill_in 'Password confirmation', with: 'password'
    click_button 'Create Account'

    within('.alert') do
      success_message = 'Your account has been created.'
      expect(page).to have_content(success_message)
    end
    expect(page).to have_content('Signed in as test@example.com')
    expect(page.current_url).to eq('http://test.lvh.me/')
  end

  scenario 'ensure subdomain uniqueness' do
    owner = User.create!(email: 'owner@example.com', password: 'password')
    Account.create!(subdomain: 'test', name: 'test', owner: owner)

    visit root_path
    click_link 'Create an account'
    fill_in 'account[name]', with: 'test'
    fill_in 'Subdomain', with: 'test'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password', exact: true
    fill_in 'Password confirmation', with: 'password'
    click_button 'Create Account'

    expect(page.current_url).to eq('http://lvh.me/accounts')
    expect(page).to have_content('Sorry, your account could not be created.')
    expect(page).to have_content('Subdomain has already been taken')
  end
end
