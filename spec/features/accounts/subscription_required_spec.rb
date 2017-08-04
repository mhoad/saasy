# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Subscriptions are required', type: :feature do
  let!(:account) { FactoryGirl.create(:account, :invalid) }

  context 'as an account owner' do
    before do
      login_as(account.owner)
      set_subdomain(account.subdomain)
    end

    scenario 'Account owner must select a plan' do
      visit root_url
      expect(page.current_url).to eq(choose_plan_url)
      within('.alert') do
        message = 'You must subscribe to a plan before you can use your account.'
        expect(page).to have_content(message)
      end
    end
  end
end
