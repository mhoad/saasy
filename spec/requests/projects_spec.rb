# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:account) { FactoryGirl.create(:account) }
  let!(:project) { FactoryGirl.create(:project, account: account) }

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

    it 'can delete a project' do
      sign_in account.owner
      expect do
        delete project_url(id: project.id, subdomain: account.subdomain)
      end.to change(account.projects, :count).by(-1)
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

    it 'can not delete a project' do
      expect do
        delete project_url(id: project.id, subdomain: account.subdomain)
      end.to change(account.projects, :count).by(0)
    end
  end
end
