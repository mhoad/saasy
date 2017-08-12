# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  name              :string
#  amount_cents      :integer          default(0), not null
#  amount_currency   :string           default("USD"), not null
#  stripe_id         :string           not null
#  live              :boolean          not null
#  billing_cycle     :string           not null
#  trial_period_days :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  projects_allowed  :integer
#
# Indexes
#
#  index_plans_on_stripe_id  (stripe_id)
#
class Plan < ApplicationRecord
  validates :amount_cents, presence: true
  validates :amount_currency, presence: true
  validates :stripe_id, presence: true
  validates :billing_cycle, presence: true
end
