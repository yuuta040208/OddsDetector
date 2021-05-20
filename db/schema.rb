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

  create_table "horses", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "places", force: :cascade do |t|
    t.bigint "race_card_id"
    t.float "odds_min", null: false, comment: "複勝オッズ（下限）"
    t.float "odds_max", null: false, comment: "複勝オッズ（上限）"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["race_card_id"], name: "index_places_on_race_card_id"
  end

  create_table "quinellas", force: :cascade do |t|
    t.bigint "first_race_card_id"
    t.bigint "second_race_card_id"
    t.float "odds", null: false, comment: "馬連オッズ"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["first_race_card_id"], name: "index_quinellas_on_first_race_card_id"
    t.index ["second_race_card_id"], name: "index_quinellas_on_second_race_card_id"
  end

  create_table "race_cards", force: :cascade do |t|
    t.bigint "race_id"
    t.bigint "horse_id"
    t.integer "bracket_number", null: false, comment: "枠番"
    t.integer "horse_number", null: false, comment: "馬番"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["horse_id"], name: "index_race_cards_on_horse_id"
    t.index ["race_id"], name: "index_race_cards_on_race_id"
  end

  create_table "races", id: :bigint, default: nil, force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.integer "number", null: false, comment: "第何レースか"
    t.string "course", null: false, comment: "コース情報"
    t.date "hold_at", null: false, comment: "開催日"
    t.datetime "start_at", null: false, comment: "発走時刻"
    t.string "description", null: false, comment: "説明（例: 第2回　大井競馬　第5日）"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scraping_targets", force: :cascade do |t|
    t.bigint "race_id"
    t.integer "race_card_id"
    t.string "url", null: false, comment: "スクレイピング対象のURL"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wides", force: :cascade do |t|
    t.bigint "first_race_card_id"
    t.bigint "second_race_card_id"
    t.float "odds_min", null: false, comment: "ワイドオッズ（下限）"
    t.float "odds_max", null: false, comment: "ワイドオッズ（上限）"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["first_race_card_id"], name: "index_wides_on_first_race_card_id"
    t.index ["second_race_card_id"], name: "index_wides_on_second_race_card_id"
  end

  create_table "wins", force: :cascade do |t|
    t.bigint "race_card_id"
    t.float "odds", null: false, comment: "単勝オッズ"
    t.datetime "crawled_at", null: false, comment: "クローリングした日時"
    t.index ["race_card_id"], name: "index_wins_on_race_card_id"
  end

  add_foreign_key "places", "race_cards"
  add_foreign_key "quinellas", "race_cards", column: "first_race_card_id"
  add_foreign_key "quinellas", "race_cards", column: "second_race_card_id"
  add_foreign_key "race_cards", "horses"
  add_foreign_key "race_cards", "races"
  add_foreign_key "wides", "race_cards", column: "first_race_card_id"
  add_foreign_key "wides", "race_cards", column: "second_race_card_id"
  add_foreign_key "wins", "race_cards"
end
