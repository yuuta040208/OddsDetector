class CreateNankanPlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_places do |t|
      t.references :nankan_race_card, foreign_key: true
      t.float :odds_min, null: false, comment: '複勝オッズ（下限）'
      t.float :odds_max, null: false, comment: '複勝オッズ（上限）'
      t.datetime :crawled_at, null: false, comment: 'クローリングした日時'
    end
  end
end
