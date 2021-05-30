class CreateJRAScrapingTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :jra_scraping_targets do |t|
      t.references :jra_race, foreign_key: true
      t.string :path, null: false, comment: 'スクレイピング対象のパス'

      t.timestamps
    end
  end
end
