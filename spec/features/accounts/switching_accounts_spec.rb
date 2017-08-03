# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Switching Accounts', type: :feature do
  let(:account_1) { FactoryGirl.create(:account) }
  let(:account_2) { FactoryGirl.create(:account) }

  before do
    account_2.users << account_1.owner
    login_as(account_1.owner)
  end

  it 'can switch between accounts' do
    set_subdomain(account_1.subdomain)
    visit root_url

    click_link Rails.configuration.application_settings['application_name']
    expect(page.current_url).to eq(root_url(subdomain: nil))
    click_link account_2.name
    expect(page.current_url).to eq(root_url(subdomain: account_2.subdomain))

    click_link Rails.configuration.application_settings['application_name']
    expect(page.current_url).to eq(root_url(subdomain: nil))
    click_link account_1.name
    expect(page.current_url).to eq(root_url(subdomain: account_1.subdomain))
  end
end
