class CreateJRAWides < ActiveRecord::Migration[6.0]
  def change
    create_table :jra_wides do |t|
      t.references :first_jra_race_card
      t.references :second_jra_race_card
      t.float :odds_min, null: false, comment: 'ワイドオッズ（下限）'
      t.float :odds_max, null: false, comment: 'ワイドオッズ（上限）'
      t.datetime :crawled_at, null: false, comment: 'クローリングした日時'
    end

    add_foreign_key :jra_wides, :jra_race_cards, column: :first_jra_race_card_id
    add_foreign_key :jra_wides, :jra_race_cards, column: :second_jra_race_card_id
  end
end
