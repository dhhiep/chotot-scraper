class AddColumnOwnerToPotentials < ActiveRecord::Migration[5.2]
  def change
    add_column :potentials, :owner, :string
  end
end
