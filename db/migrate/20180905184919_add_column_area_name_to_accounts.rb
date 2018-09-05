class AddColumnAreaNameToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :area_name, :string
  end
end
