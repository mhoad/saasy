# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Adding Projects', type: :feature do
  let(:account) { FactoryGirl.create(:account) }

  context 'as the accounts owner' do
    before do
      login_as(account.owner)
    end

    it 'can add an objective' do
      visit root_url(subdomain: account.subdomain)
      click_link 'Add Project'
      fill_in 'Title', with: 'ACME Corp Website'
      fill_in 'Description', with: 'Make more money!'
      click_button 'Add Project'

      expect(page).to have_content('Your project has been added.')
    end
  end
end
