# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160504161856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "purpose"
    t.string   "key"
    t.string   "key_hint"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "network"
    t.string   "domain"
    t.string   "antivirus"
    t.string   "router1"
    t.string   "router2"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "state"
    t.string   "name"
    t.string   "doctor_name"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer  "companies_id"
    t.string   "state"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "company_id"
    t.text     "features"
  end

  add_index "inventory_items", ["companies_id"], name: "index_inventory_items_on_companies_id", using: :btree
  add_index "inventory_items", ["company_id"], name: "index_inventory_items_on_company_id", using: :btree

  create_table "item_joiners", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "purchase_order_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "item_joiners", ["item_id"], name: "index_item_joiners_on_item_id", using: :btree
  add_index "item_joiners", ["purchase_order_id"], name: "index_item_joiners_on_purchase_order_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "login_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "login_sessions", ["user_id"], name: "index_login_sessions_on_user_id", using: :btree

  create_table "purchase_order_vendors", force: :cascade do |t|
    t.integer  "vendor_id"
    t.integer  "purchase_order_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "purchase_order_vendors", ["purchase_order_id"], name: "index_purchase_order_vendors_on_purchase_order_id", using: :btree
  add_index "purchase_order_vendors", ["vendor_id"], name: "index_purchase_order_vendors_on_vendor_id", using: :btree

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "po_number"
    t.integer  "company_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "payment"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "purchase_orders", ["company_id"], name: "index_purchase_orders_on_company_id", using: :btree

  create_table "service_logs", force: :cascade do |t|
    t.datetime "date"
    t.string   "length"
    t.text     "notes"
    t.string   "state"
    t.integer  "companies_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "company_id"
    t.boolean  "payment"
  end

  add_index "service_logs", ["companies_id"], name: "index_service_logs_on_companies_id", using: :btree
  add_index "service_logs", ["company_id"], name: "index_service_logs_on_company_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "state"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "vendors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "inventory_items", "companies"
  add_foreign_key "item_joiners", "items"
  add_foreign_key "login_sessions", "users"
  add_foreign_key "purchase_order_vendors", "purchase_orders"
  add_foreign_key "purchase_order_vendors", "vendors"
  add_foreign_key "purchase_orders", "companies"
  add_foreign_key "service_logs", "companies"
end
