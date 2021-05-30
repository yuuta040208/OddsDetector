class CreateJRARaces < ActiveRecord::Migration[6.0]
  def change
    create_table :jra_races do |t|
      t.string :name, null: false, comment: '名前'
      t.integer :number, null: false, comment: '第何レースか'
      t.string :course, null: false, comment: 'コース情報'
      t.date :hold_at, null: false, comment: '開催日'
      t.datetime :start_at, null: false, comment: '発走時刻'
      t.string :description, null: false, comment: '説明（例: 2回東京9日目）'

      t.timestamps
    end
  end
end
