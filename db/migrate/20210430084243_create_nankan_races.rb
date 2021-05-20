class CreateNankanRaces < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_races, id: false do |t|
      t.column :id, 'bigint PRIMARY KEY', comment: 'レースID (例: 2021043020020501)'
      t.string :name, null: false, comment: '名前'
      t.integer :number, null: false, comment: '第何レースか'
      t.string :course, null: false, comment: 'コース情報'
      t.date :hold_at, null: false, comment: '開催日'
      t.datetime :start_at, null: false, comment: '発走時刻'
      t.string :description, null: false, comment: '説明（例: 第2回　大井競馬　第5日）'

      t.timestamps
    end
  end
end
