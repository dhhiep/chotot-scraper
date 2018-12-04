# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_04_034527) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "account_id"
    t.string "account_oid"
    t.string "address"
    t.string "create_time"
    t.string "deviation"
    t.string "email"
    t.string "email_verified"
    t.string "avatar"
    t.string "facebook_id"
    t.string "facebook_token"
    t.string "full_name"
    t.string "lat"
    t.string "lng"
    t.string "long_term_facebook_token"
    t.string "phone"
    t.string "phone_verified"
    t.string "start_time"
    t.string "update_time"
    t.string "is_active"
    t.string "name_correct"
    t.integer "status", default: 0
    t.integer "wse_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
    t.string "category_names"
    t.datetime "inserted_at"
    t.boolean "favorite", default: false
    t.string "area_name"
    t.integer "region_id"
    t.integer "area_id"
    t.string "list_id"
    t.string "category_id"
    t.string "ad_id"
    t.string "category_code"
    t.index ["account_id"], name: "index_accounts_on_account_id"
    t.index ["account_oid"], name: "index_accounts_on_account_oid"
    t.index ["list_id"], name: "index_accounts_on_list_id"
    t.index ["status"], name: "index_accounts_on_status"
    t.index ["wse_status"], name: "index_accounts_on_wse_status"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.integer "region_id"
    t.integer "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_areas_on_area_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "base_url"
    t.text "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ct_category_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "potential_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lists", force: :cascade do |t|
    t.string "list_id"
    t.string "account_id"
    t.string "category_id"
    t.string "ad_id"
    t.string "category_name"
    t.string "area_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "area_id"
    t.integer "region_id"
    t.index ["list_id"], name: "index_lists_on_list_id"
  end

  create_table "potentials", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.integer "account_id"
    t.datetime "remind_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_regions_on_region_id", unique: true
  end

  create_table "summaries", force: :cascade do |t|
    t.string "uuid"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zalos", force: :cascade do |t|
    t.string "account_id"
    t.string "name"
    t.string "avatar"
    t.string "gender"
    t.string "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
