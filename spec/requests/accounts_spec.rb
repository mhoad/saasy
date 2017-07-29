# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  describe 'GET /accounts/new' do
    it 'returns the page as expected' do
      get new_account_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /accounts' do
    context 'with valid attributes' do
      it 'adds an account' do
        account_params = { name: 'MyString', subdomain: 'test',
                           owner_attributes: {
                             email: 'test@example.com',
                             password: 'password123',
                             password_confirmation: 'password123'
                           } }

        expect do
          post accounts_path, params: { account: account_params }
        end.to change(Account, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not add an account' do
        account_params = { name: nil, subdomain: 'test',
                           owner_attributes: {
                             email: 'test@example.com',
                             password: 'password123',
                             password_confirmation: 'password123'
                           } }
        expect do
          post accounts_path, params: {
            account: account_params
          }
        end.to_not change(Account, :count)
      end
    end
  end
end
