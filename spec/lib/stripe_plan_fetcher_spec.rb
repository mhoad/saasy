# frozen_string_literal: true

require 'rails_helper'
require 'stripe_plan_fetcher'

describe StripePlanFetcher do
  let(:faux_plan) do
    double('Plan',
           id: 'starter',
           name: 'Starter',
           amount: 995,
           currency: 'AUD',
           interval: 'month',
           trial_period_days: '',
           livemode: false)
  end

  # Ensure that when StripePlanFetcher.store_locally is called that it calls
  # the Stripe::Plan#all method from the Stripe gem. This method returns an
  # array of plans which will be iterated over by StripePlanFetcher.store_locally
  # for each of the plans Plan.create will be called so it is stored locally
  it 'fetches and stores plans' do
    expect(Stripe::Plan).to receive(:all).and_return([faux_plan])
    expect(Plan).to receive(:create).with(stripe_id: 'starter',
                                          name: 'Starter',
                                          amount_cents: 995,
                                          amount_currency: 'AUD',
                                          billing_cycle: 'month',
                                          trial_period_days: '',
                                          live: false)

    StripePlanFetcher.store_locally
  end

  # We want to ensure that we don't recreate plans that we already have a
  # copy of in the database. Instead we find those and update them as needed.
  it 'checks and updates plans' do
    expect(Stripe::Plan).to receive(:all).and_return([faux_plan])
    expect(Plan).to receive(:find_by).with(stripe_id: faux_plan.id)
                                     .and_return(plan = double)

    expect(plan).to receive(:update).with(name: 'Starter',
                                          amount_cents: 995,
                                          amount_currency: 'AUD',
                                          billing_cycle: 'month',
                                          trial_period_days: '',
                                          live: false)

    expect(Plan).to_not receive(:create)

    StripePlanFetcher.store_locally
  end
end
