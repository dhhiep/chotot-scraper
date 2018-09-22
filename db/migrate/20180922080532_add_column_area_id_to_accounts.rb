class AddColumnAreaIdToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :area_id, :integer
  end
end
