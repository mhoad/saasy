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

    it 'can add a project' do
      click_link 'Add Project'
      fill_in 'Name', with: 'ACME Corp Website'
      fill_in 'Description', with: 'Make more money!'
      click_button 'Create Project'

      expect(page).to have_content('Project was successfully created.')
    end
  end

  context 'as a user who is not logged in' do
    before do
      set_subdomain(account.subdomain)
    end

    it 'can not access the page' do
      visit root_url
      expect(page.current_url).to eq(new_user_session_url)
    end
  end
end
