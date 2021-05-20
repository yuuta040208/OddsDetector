class CreateNankanWins < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_wins do |t|
      t.references :nankan_race_card, foreign_key: true
      t.float :odds, null: false, comment: '単勝オッズ'
      t.datetime :crawled_at, null: false, comment: 'クローリングした日時'
    end
  end
end
