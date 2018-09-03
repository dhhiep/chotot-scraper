class AddColumnHideToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :hide, :boolean, :default => false
  end
end
