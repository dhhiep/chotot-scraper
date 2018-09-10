class AddColumnRegionIdToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :region_id, :integer
  end
end
