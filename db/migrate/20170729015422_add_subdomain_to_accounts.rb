class AddSubdomainToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :subdomain, :string, null: false, limit: 60
    add_index :accounts, :subdomain, unique: true
  end
end
