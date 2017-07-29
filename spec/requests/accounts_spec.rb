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
        account_params = FactoryGirl.attributes_for(:account)
        expect do
          post accounts_path, params: {
            account: account_params
          }
        end.to change(Account, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not add an account' do
        account_params = FactoryGirl.attributes_for(:account, :invalid)
        expect do
          post accounts_path, params: {
            account: account_params
          }
        end.to_not change(Account, :count)
      end
    end
  end
end
