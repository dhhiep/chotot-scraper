class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :account_id
      t.string :account_name
      t.string :name_correct
      t.string :phone
      t.string :area
      t.integer :status, default: 0
      t.integer :wse_status, default: 0

      t.timestamps
    end
  end
end
