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

ActiveRecord::Schema.define(version: 20161106130742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boxes", force: :cascade do |t|
    t.integer  "home_team_num"
    t.integer  "away_team_num"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "sheet_id"
    t.string   "home_team_id"
    t.string   "away_team_id"
  end

  add_index "boxes", ["home_team_id", "away_team_id", "sheet_id"], name: "index_boxes_on_home_team_id_and_away_team_id_and_sheet_id", unique: true, using: :btree
  add_index "boxes", ["sheet_id"], name: "index_boxes_on_sheet_id", using: :btree

  create_table "sheets", force: :cascade do |t|
    t.string   "home_team"
    t.string   "away_team"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "boxes", "sheets"
end
