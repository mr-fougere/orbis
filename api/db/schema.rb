# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_11_172538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_configurations", force: :cascade do |t|
    t.integer "board_height", default: 8, null: false
    t.integer "board_width", default: 8, null: false
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.integer "game_mode"
    t.jsonb "initial_disks", default: [], null: false
    t.integer "starting_side", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_configurations_on_game_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.boolean "is_admin", default: false, null: false
    t.bigint "player_id", null: false
    t.integer "side", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["player_id"], name: "index_game_players_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.jsonb "board_state", default: [], null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 0
    t.string "stream_token"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_games_on_code", unique: true
    t.index ["stream_token"], name: "index_games_on_stream_token", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "game_configurations", "games"
  add_foreign_key "game_players", "games"
  add_foreign_key "game_players", "players"
end
