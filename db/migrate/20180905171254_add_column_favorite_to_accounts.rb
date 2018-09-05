class AddColumnFavoriteToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :favorite, :boolean, default: false
  end
end
