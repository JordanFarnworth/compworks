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

ActiveRecord::Schema.define(version: 20150518160726) do

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
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.text     "features"
  end

  add_index "inventory_items", ["company_id"], name: "index_inventory_items_on_company_id", using: :btree

  create_table "login_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "login_sessions", ["user_id"], name: "index_login_sessions_on_user_id", using: :btree

  create_table "service_logs", force: :cascade do |t|
    t.datetime "date"
    t.string   "length"
    t.string   "service_preformed"
    t.text     "notes"
    t.string   "state"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "company_id"
  end

  add_index "service_logs", ["company_id"], name: "index_service_logs_on_company_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "state"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
