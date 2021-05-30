class CreateJRAHorses < ActiveRecord::Migration[6.0]
  def change
    create_table :jra_horses do |t|
      t.string :name, null: false, comment: '名前'

      t.timestamps
    end
  end
end
