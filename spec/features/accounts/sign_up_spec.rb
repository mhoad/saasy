# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Accounts', type: :feature do
  scenario 'creating an account' do
    visit root_path

    click_link 'Create an account'
    fill_in 'Name', with: 'test'
    click_button 'Create Account'

    within('.alert') do
      success_message = 'Your account has been created.'
      expect(page).to have_content(success_message)
    end
  end
end
