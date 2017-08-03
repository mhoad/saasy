# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Inviting users', type: :feature do
  # include ActiveJob::TestHelper
  let(:account) { FactoryGirl.create(:account) }

  before do
    set_subdomain(account.subdomain)
    login_as(account.owner)
    visit root_url
  end

  scenario 'invites a user successfully' do
    # click_link 'Users'
    click_link 'Invite user'
    fill_in 'Email', with: 'test@example.com'
    perform_enqueued_jobs do
      click_button 'Invite User'
    end

    # Make sure it gets added to the job queue and then execute the job
    # expect(enqueued_jobs.size).to eq(1)
    # invitation_id = enqueued_jobs.first[:args].first
    # perform_enqueued_jobs { InvitationEmailJob.perform_now(invitation_id) }

    expect(page).to have_content('test@example.com has been invited.')
    expect(page.current_url).to eq(root_url)

    email = find_email('test@example.com')
    expect(email).to be_present
    expect(email.subject).to eq("Invitation to join #{account.name} on #{Rails.configuration.application_settings['application_name']}")
  end
end
