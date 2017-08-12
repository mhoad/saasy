# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::PlansController, type: :controller do
  context 'as an account owner' do
    let!(:account) { FactoryGirl.create(:account) }
    let!(:starter_plan) { FactoryGirl.create(:plan, name: 'Starter', stripe_id: 'silver', projects_allowed: 1) }
    let!(:silver_plan) { FactoryGirl.create(:plan, name: 'Silver', stripe_id: 'silver', projects_allowed: 3) }

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(account.owner)
      allow(controller).to receive(:current_account).and_return(account)

      account.plan = silver_plan
      account.projects << FactoryGirl.create_list(:project, 3)
      account.save
    end

    context 'with 3 projects' do
      it 'cannot switch to the starter plan' do
        expect(Stripe::Customer).not_to receive(:retrieve)

        put :switch, params: { plan_id: starter_plan.id }
        expect(flash[:alert]).to eq(
          "You cannot switch to that plan. Your account is over that plan's limit."
        )
        expect(response).to redirect_to(choose_plan_path)

        account.reload
        expect(account.plan).to eq(silver_plan)
      end
    end
  end
end
