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

ActiveRecord::Schema.define(version: 2019_04_27_202620) do

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "cpf", limit: 14, null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_clients_on_cpf", unique: true
    t.index ["email"], name: "index_clients_on_email"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "imei", limit: 14, null: false
    t.string "phone_model", null: false
    t.decimal "full_price", precision: 10, scale: 2, null: false
    t.integer "payments", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_subscriptions_on_client_id"
  end

end
