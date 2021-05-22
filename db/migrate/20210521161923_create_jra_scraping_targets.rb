class CreateJRAScrapingTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :jra_scraping_targets do |t|
      t.bigint :jra_race_id
      t.integer :jra_race_card_id
      t.string :url, null: false, comment: 'スクレイピング対象のURL'

      t.timestamps
    end
  end
end
