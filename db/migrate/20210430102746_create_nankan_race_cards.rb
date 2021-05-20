class CreateNankanRaceCards < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_race_cards do |t|
      t.references :nankan_race, foreign_key: true
      t.references :nankan_horse, foreign_key: true
      t.integer :bracket_number, null: false, comment: '枠番'
      t.integer :horse_number, null: false, comment: '馬番'

      t.timestamps
    end
  end
end
