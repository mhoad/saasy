# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }
  let!(:account_a_project) { FactoryGirl.create(:project, name: 'Account A Project', account: account_a) }
  let!(:account_b_project) { FactoryGirl.create(:project, name: 'Account B Project', account: account_b) }

  context 'index' do
    scenario "displays only account A's project" do
      set_subdomain(account_a.subdomain)
      login_as(account_a.owner)
      visit root_url

      expect(page).to have_content('Account A Project')
      expect(page).to_not have_content('Account B Project')
    end

    scenario "displays only account B's project" do
      set_subdomain(account_b.subdomain)
      login_as(account_b.owner)
      visit root_url

      expect(page).to have_content('Account B Project')
      expect(page).to_not have_content('Account A Project')
    end

    scenario 'unable to manually view other accounts projects' do
      set_subdomain(account_b.subdomain)
      login_as(account_b.owner)
      visit project_path(account_a_project)

      expect(page).to_not have_content('Account A Project')
      expect(page).to have_content('Project not found.')
      expect(page.current_path).to eq(account_root_path)
    end
  end
end
