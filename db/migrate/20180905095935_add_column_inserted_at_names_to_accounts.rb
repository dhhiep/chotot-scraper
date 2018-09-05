class AddColumnInsertedAtNamesToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :inserted_at, :datetime
  end
end
