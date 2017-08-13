class CreateSubscriptionEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_events do |t|
      t.references :account, foreign_key: true
      t.string :type
      t.string :stripe_id
      t.jsonb :data

      t.datetime :created_at
    end
    add_index :subscription_events, :stripe_id, unique: true
  end
end
