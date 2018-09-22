class AddColumnAreaIdAndRegionIdToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :area_id, :integer
    add_column :lists, :region_id, :integer
  end
end
