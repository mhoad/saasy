# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Editing Projects', type: :feature do
  let(:project) { FactoryGirl.create(:project, name: 'International Website') }

  before do
    set_subdomain(project.account.subdomain)
  end

  context 'as the accounts owner' do
    before do
      login_as(project.account.owner)
      visit project_url(project)
      click_link 'Edit Project'
    end

    context 'with valid information' do
      it 'can update a project' do
        fill_in 'Name', with: 'New Mobile Application'
        click_button 'Update Project'

        expect(page).to have_content('Successfully updated project.')
        expect(page).to have_content('New Mobile Application')
        expect(page).to_not have_content(project.name)
      end
    end

    context 'with invalid information' do
      it 'can not update a project' do
        fill_in 'Name', with: ''
        click_button 'Update Project'

        expect(page).to have_content('Error updating project.')
        expect(page).to have_content("Project Name can't be blank")
        expect(page).to have_content('Edit Project')
      end
    end
  end

  context 'as a user who is not logged in' do
    it 'can not access the page' do
      visit project_url(project)
      expect(page.current_url).to eq(new_user_session_url)
    end
  end
end
