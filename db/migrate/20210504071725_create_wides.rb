class CreateWides < ActiveRecord::Migration[6.0]
  def change
    create_table :wides do |t|
      t.references :first_race_card
      t.references :second_race_card
      t.float :odds_min, null: false, comment: 'ワイドオッズ（下限）'
      t.float :odds_max, null: false, comment: 'ワイドオッズ（上限）'
      t.datetime :crawled_at, null: false, comment: 'クローリングした日時'
    end

    add_foreign_key :wides, :race_cards, column: :first_race_card_id
    add_foreign_key :wides, :race_cards, column: :second_race_card_id
  end
end
