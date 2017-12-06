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

ActiveRecord::Schema.define(version: 20171206115154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boxes", force: :cascade do |t|
    t.integer "home_team_num"
    t.integer "away_team_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sheet_id"
    t.string "home_team_id"
    t.string "away_team_id"
    t.text "owner_name"
    t.integer "number", null: false
    t.index ["home_team_id", "away_team_id", "sheet_id"], name: "index_boxes_on_home_team_id_and_away_team_id_and_sheet_id", unique: true
    t.index ["sheet_id", "number"], name: "index_boxes_on_sheet_id_and_number", unique: true
    t.index ["sheet_id"], name: "index_boxes_on_sheet_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "home_team"
    t.integer "away_team"
    t.text "league"
    t.datetime "game_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sheets", force: :cascade do |t|
    t.string "home_team"
    t.string "away_team"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "sheet_code"
    t.text "password"
    t.integer "box_amount"
    t.integer "home_team_score_row", array: true
    t.integer "away_team_score_row", array: true
    t.boolean "closed"
    t.bigint "user_id"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_sheets_on_game_id"
    t.index ["sheet_code"], name: "index_sheets_on_sheet_code", unique: true
    t.index ["user_id", "game_id", "name"], name: "index_sheets_on_user_id_and_game_id_and_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "boxes", "sheets"
  add_foreign_key "sheets", "games"
  add_foreign_key "sheets", "users"
end
