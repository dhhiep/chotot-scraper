class AddColumnCtCategoryIdToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :ct_category_id, :integer
  end
end
