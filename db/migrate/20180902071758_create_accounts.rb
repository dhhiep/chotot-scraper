class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :account_id
      t.string :account_oid
      t.string :address
      t.string :create_time
      t.string :deviation
      t.string :email
      t.string :email_verified
      t.string :avatar
      t.string :facebook_id
      t.string :facebook_token
      t.string :full_name
      t.string :lat
      t.string :lng
      t.string :long_term_facebook_token
      t.string :phone
      t.string :phone_verified
      t.string :start_time
      t.string :update_time
      t.string :is_active

      t.string :name_correct
      t.integer :status, default: 0
      t.integer :wse_status, default: 0

      t.timestamps
    end
  end
end
