class AddTokenToInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :invitations, :token, :string, null: false
    add_index :invitations, :token
  end
end
