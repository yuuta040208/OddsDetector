class CreateWins < ActiveRecord::Migration[6.0]
  def change
    create_table :wins do |t|
      t.references :race_card, foreign_key: true
      t.float :odds, null: false, comment: '単勝オッズ'

      t.timestamps
    end
  end
end
