class AddIndicesForRegionsAndAreas < ActiveRecord::Migration[5.2]
  def change
    add_index :regions, :region_id, unique: true
    add_index :areas, :area_id, unique: true
  end
end
