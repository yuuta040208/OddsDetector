# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_04_093340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nankan_horses", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nankan_places", force: :cascade do |t|
    t.bigint "nankan_race_card_id"
    t.float "odds_min", null: false, comment: "複勝オッズ（下限）"
    t.float "odds_max", null: false, comment: "複勝オッズ（上限）"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["nankan_race_card_id"], name: "index_nankan_places_on_nankan_race_card_id"
  end

  create_table "nankan_quinellas", force: :cascade do |t|
    t.bigint "first_nankan_race_card_id"
    t.bigint "second_nankan_race_card_id"
    t.float "odds", null: false, comment: "馬連オッズ"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["first_nankan_race_card_id"], name: "index_nankan_quinellas_on_first_nankan_race_card_id"
    t.index ["second_nankan_race_card_id"], name: "index_nankan_quinellas_on_second_nankan_race_card_id"
  end

  create_table "nankan_race_cards", force: :cascade do |t|
    t.bigint "nankan_race_id"
    t.bigint "nankan_horse_id"
    t.integer "bracket_number", null: false, comment: "枠番"
    t.integer "horse_number", null: false, comment: "馬番"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["nankan_horse_id"], name: "index_nankan_race_cards_on_nankan_horse_id"
    t.index ["nankan_race_id"], name: "index_nankan_race_cards_on_nankan_race_id"
  end

  create_table "nankan_races", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.integer "number", null: false, comment: "第何レースか"
    t.string "course", null: false, comment: "コース情報"
    t.date "hold_at", null: false, comment: "開催日"
    t.datetime "start_at", null: false, comment: "発走時刻"
    t.string "description", null: false, comment: "説明（例: 第2回　大井競馬　第5日）"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nankan_scraping_targets", force: :cascade do |t|
    t.bigint "nankan_race_id"
    t.integer "nankan_race_card_id"
    t.string "url", null: false, comment: "スクレイピング対象のURL"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nankan_wides", force: :cascade do |t|
    t.bigint "first_nankan_race_card_id"
    t.bigint "second_nankan_race_card_id"
    t.float "odds_min", null: false, comment: "ワイドオッズ（下限）"
    t.float "odds_max", null: false, comment: "ワイドオッズ（上限）"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["first_nankan_race_card_id"], name: "index_nankan_wides_on_first_nankan_race_card_id"
    t.index ["second_nankan_race_card_id"], name: "index_nankan_wides_on_second_nankan_race_card_id"
  end

  create_table "nankan_wins", force: :cascade do |t|
    t.bigint "nankan_race_card_id"
    t.float "odds", null: false, comment: "単勝オッズ"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["nankan_race_card_id"], name: "index_nankan_wins_on_nankan_race_card_id"
  end

  add_foreign_key "nankan_places", "nankan_race_cards"
  add_foreign_key "nankan_quinellas", "nankan_race_cards", column: "first_nankan_race_card_id"
  add_foreign_key "nankan_quinellas", "nankan_race_cards", column: "second_nankan_race_card_id"
  add_foreign_key "nankan_race_cards", "nankan_horses"
  add_foreign_key "nankan_race_cards", "nankan_races"
  add_foreign_key "nankan_wides", "nankan_race_cards", column: "first_nankan_race_card_id"
  add_foreign_key "nankan_wides", "nankan_race_cards", column: "second_nankan_race_card_id"
  add_foreign_key "nankan_wins", "nankan_race_cards"
end
