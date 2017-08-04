# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationEmailJob, type: :job do
  describe '#perform' do
    let(:invitation) { FactoryGirl.create(:invitation) }

    it 'calls on the InvitationMailer' do
      allow(InvitationMailer).to receive_message_chain(:invite, :deliver_now)
      InvitationEmailJob.new.perform(invitation.id)
      expect(InvitationMailer).to have_received(:invite)
    end

    it 'delivers an invitation email' do
      expect do
        InvitationEmailJob.new.perform(invitation.id)
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end

  describe '.perform_later' do
    it 'adds the job to the queue :mailers' do
      allow(InvitationMailer).to receive_message_chain(:invite, :deliver_now)
      InvitationEmailJob.perform_later(1)
      expect(enqueued_jobs.last[:job]).to eq InvitationEmailJob
    end
  end
end
