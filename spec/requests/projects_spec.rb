# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:account) { FactoryGirl.create(:account) }

  context 'as an authenticated user' do
    context 'with valid attributes' do
      it 'adds a project' do
        project_params = { name: 'My Website', description: 'test', account: account.id }
        sign_in account.owner
        expect do
          post projects_url(subdomain: account.subdomain), params: {
            project: project_params
          }
        end.to change(account.projects, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not add a project' do
        project_params = { name: nil, description: 'test', account: account.id }
        sign_in account.owner
        expect do
          post projects_url(subdomain: account.subdomain), params: {
            project: project_params
          }
        end.to change(account.projects, :count).by(0)
      end
    end
  end

  context 'as an unauthenticated user' do
    it 'does not add a project' do
      project_params = { name: 'My Website', description: 'test', account: account.id }
      expect do
        post projects_url(subdomain: account.subdomain), params: {
          project: project_params
        }
      end.to change(account.projects, :count).by(0)
    end
  end
end
