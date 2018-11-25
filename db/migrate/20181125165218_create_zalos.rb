class CreateZalos < ActiveRecord::Migration[5.2]
  def change
    create_table :zalos do |t|
      t.string :account_id
      t.string :name
      t.string :avatar
      t.string :gender
      t.string :birthday

      t.timestamps
    end
  end
end
