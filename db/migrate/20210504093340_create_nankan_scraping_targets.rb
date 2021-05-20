class CreateNankanScrapingTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :nankan_scraping_targets do |t|
      t.bigint :nankan_race_id
      t.integer :nankan_race_card_id
      t.string :url, null: false, comment: 'スクレイピング対象のURL'

      t.timestamps
    end
  end
end
