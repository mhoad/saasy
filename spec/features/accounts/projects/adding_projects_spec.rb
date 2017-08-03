# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Adding Projects', type: :feature do
  let(:account) { FactoryGirl.create(:account) }

  context 'as the accounts owner' do
    before do
      login_as(account.owner)
      set_subdomain(account.subdomain)
      visit root_url
    end

    it 'can add an objective' do
      click_link 'Add Project'
      fill_in 'Name', with: 'ACME Corp Website'
      fill_in 'Description', with: 'Make more money!'
      click_button 'Create Project'

      expect(page).to have_content('Project was successfully created.')
    end
  end
end
