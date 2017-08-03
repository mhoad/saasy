class AddAccountIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :account, foreign_key: true
  end
end
