class CreateJRAQuinellas < ActiveRecord::Migration[6.0]
  def change
    create_table :jra_quinellas do |t|
      t.references :first_jra_race_card
      t.references :second_jra_race_card
      t.float :odds, null: false, comment: '馬連オッズ'
      t.datetime :crawled_at, null: false, comment: 'クローリングした日時'
    end

    add_foreign_key :jra_quinellas, :jra_race_cards, column: :first_jra_race_card_id
    add_foreign_key :jra_quinellas, :jra_race_cards, column: :second_jra_race_card_id
  end
end
