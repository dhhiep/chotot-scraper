class CreateSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :summaries do |t|
      t.string :uuid
      t.string :description
      t.timestamps
    end
  end
end
