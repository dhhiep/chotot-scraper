class AddIndices < ActiveRecord::Migration[5.2]
  def change
    add_index :lists, :list_id
    add_index :accounts, :account_id
    add_index :accounts, :account_oid
    add_index :accounts, :status
    add_index :accounts, :wse_status
  end
end
