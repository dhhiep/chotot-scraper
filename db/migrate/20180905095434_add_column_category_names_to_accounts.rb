class AddColumnCategoryNamesToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :category_names, :string
  end
end
