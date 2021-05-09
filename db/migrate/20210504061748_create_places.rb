class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.references :race_card, foreign_key: true
      t.float :odds_min, null: false, comment: '複勝オッズ（下限）'
      t.float :odds_max, null: false, comment: '複勝オッズ（上限）'

      t.timestamps
    end
  end
end
