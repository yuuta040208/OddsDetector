class CreateScrapingTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :scraping_targets do |t|
      t.bigint :race_id
      t.integer :race_card_id
      t.string :url, null: false, comment: 'スクレイピング対象のURL'

      t.timestamps
    end
  end
end
