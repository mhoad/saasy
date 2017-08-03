# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User account sign in', type: :feature do
  let!(:account) { FactoryGirl.create(:account) }
  before { set_subdomain(account.subdomain) }

  scenario 'signs in as an account owner successfully' do
    visit root_url
    fill_in 'Email', with: account.owner.email
    fill_in 'Password', with: account.owner.password
    click_button 'Log in'

    expect(page).to have_content("Signed in as #{account.owner.email}")
    expect(page.current_url).to eq(root_url(subdomain: account.subdomain))
  end

  scenario 'sends unauthenticated users to a sign in page' do
    visit root_url
    expect(page.current_url).to eq(new_user_session_url)
  end

  scenario 'attempts sign in with invalid password and fails' do
    visit root_url
    fill_in 'Email', with: account.owner.email
    fill_in 'Password', with: 'incorrect_password'
    click_button 'Log in'

    expect(page).to_not have_content("Signed in as #{account.owner.email}")
    expect(page).to have_content('Invalid Email or password.')
    expect(page.current_url).to eq(new_user_session_url)
  end
end