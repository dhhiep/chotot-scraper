class AddColumnsToMigrateFromListToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :list_id, :string
    add_column :accounts, :category_id, :string
    add_column :accounts, :ad_id, :string
    add_column :accounts, :category_code, :string
  end
end
