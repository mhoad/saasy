# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Editing Projects', type: :feature do
  let(:project) { FactoryGirl.create(:project) }

  before do
    set_subdomain(project.account.subdomain)
  end

  context 'as the accounts owner' do
    before do
      login_as(project.account.owner)
      visit project_url(project)
    end

    it 'can delete a project' do
      click_link 'Delete Project'
      expect(page).to have_content('Successfully deleted project.')
    end
  end
end
