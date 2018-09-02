class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :list_id
      t.string :account_id
      t.string :category_id
      t.string :ad_id
      t.string :category_name
      t.string :area_name

      t.timestamps
    end
  end
end
