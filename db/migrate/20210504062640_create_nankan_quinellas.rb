class CreateNankanQuinellas < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_quinellas do |t|
      t.references :first_nankan_race_card
      t.references :second_nankan_race_card
      t.float :odds, null: false, comment: '馬連オッズ'
      t.datetime :crawled_at, null: false, comment: 'クローリングした日時'
    end

    add_foreign_key :nankan_quinellas, :nankan_race_cards, column: :first_nankan_race_card_id
    add_foreign_key :nankan_quinellas, :nankan_race_cards, column: :second_nankan_race_card_id
  end
end
