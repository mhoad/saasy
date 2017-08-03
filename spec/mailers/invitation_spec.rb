# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationMailer, type: :mailer do
  describe 'invite' do
    let(:invitation) { FactoryGirl.create(:invitation) }

    before do
      @mail = InvitationMailer.invite(invitation)
    end

    context 'headers' do
      it 'renders the subject' do
        expect(@mail.subject).to eq(
          "Invitation to join #{invitation.account.name} on #{Rails.configuration.application_settings['application_name']}"
        )
      end

      it 'sends the right email' do
        expect(@mail.to).to eq [invitation.email]
      end

      it 'renders the from email' do
        expect(@mail.from).to eq ['from@example.com']
      end

      it 'includes the correct url with the users token' do
        # expect(@mail.body.encoded).to include confirmation_url(token: invitation.token)
      end
    end
  end
end
