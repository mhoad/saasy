# frozen_string_literal: true

# We want to ensure that we always have an up to date copy
# of all the Stripe plans locally saved in the database.
class StripePlanFetcher
  def self.store_locally
    Stripe::Plan.all.each do |plan|
      local_plan = Plan.find_by(stripe_id: plan.id)
      if !local_plan.nil?
        update_plan(local_plan, plan)
      else
        create_plan(plan)
      end
    end
  end

  def self.create_plan(plan)
    Plan.create(
      name: plan.name,
      amount_cents: plan.amount,
      amount_currency: plan.currency.upcase,
      billing_cycle: plan.interval,
      trial_period_days: plan.trial_period_days,
      stripe_id: plan.id,
      live: plan.livemode
    )
  end

  def self.update_plan(local_plan, updated_plan)
    local_plan.update(name: updated_plan.name,
                      amount_cents: updated_plan.amount,
                      amount_currency: updated_plan.currency,
                      billing_cycle: updated_plan.interval,
                      trial_period_days: updated_plan.trial_period_days,
                      live: updated_plan.livemode)
  end
end
