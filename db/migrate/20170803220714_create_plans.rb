class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.monetize :amount, null: true
      t.string :stripe_id, null: false
      t.boolean :live, null: false
      t.string :billing_cycle, null: false
      t.integer :trial_period_days 

      t.timestamps
    end
    add_index :plans, :stripe_id
  end
end
