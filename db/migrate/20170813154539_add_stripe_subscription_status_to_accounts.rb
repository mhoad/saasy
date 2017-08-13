class AddStripeSubscriptionStatusToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :stripe_subscription_status, :string
  end
end
