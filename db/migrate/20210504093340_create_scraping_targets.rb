class CreateScrapingTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :scraping_targets do |t|
      t.references :race_card, foreign_key: true
      t.string :url, null: false, comment: 'スクレイピング対象のURL'

      t.timestamps
    end
  end
end
