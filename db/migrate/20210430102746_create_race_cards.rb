class CreateRaceCards < ActiveRecord::Migration[6.0]
  def change
    create_table :race_cards do |t|
      t.references :race, foreign_key: true
      t.references :horse, foreign_key: true
      t.integer :bracket_number, null: false, comment: '枠番'
      t.integer :horse_number, null: false, comment: '馬番'

      t.timestamps
    end
  end
end
