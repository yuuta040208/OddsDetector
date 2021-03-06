class CreateNankanHorses < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_horses, id: false do |t|
      t.column :id, 'bigint PRIMARY KEY', comment: '競走馬ID (例: 2018101015)'
      t.string :name, null: false, comment: '名前'

      t.timestamps
    end
  end
end
