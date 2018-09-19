class CreatePotentials < ActiveRecord::Migration[5.2]
  def change
    create_table :potentials do |t|
      t.string :name
      t.string :phone
      t.integer :account_id
      t.datetime :remind_at

      t.timestamps
    end
  end
end
