class IndexColumnListIdInAccounts < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :list_id
  end
end
