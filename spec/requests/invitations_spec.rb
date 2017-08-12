# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invitations', type: :request do
  let(:account) { FactoryGirl.create(:account) }

  context 'as an authenticated user' do
    context 'with valid attributes' do
      it 'creates an invitation' do
        invitation_params = { email: 'test@example.com', account: account.id }
        sign_in account.owner
        expect do
          post invitations_url(subdomain: account.subdomain), params: {
            invitation: invitation_params
          }
        end.to change(account.invitations, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create an invitation' do
        invitation_params = { email: nil, account: account.id }
        sign_in account.owner
        expect do
          post invitations_url(subdomain: account.subdomain), params: {
            invitation: invitation_params
          }
        end.to change(account.projects, :count).by(0)
      end
    end
  end

  context 'as an unauthenticated user' do
    it 'does not create an invitation' do
      invitation_params = { email: 'test@example.com', account: account.id }
      expect do
        post invitations_url(subdomain: account.subdomain), params: {
          invitation: invitation_params
        }
      end.to change(account.invitations, :count).by(0)
    end
  end
end
