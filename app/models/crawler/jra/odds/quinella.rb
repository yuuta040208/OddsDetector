# frozen_string_literal: true

class Crawler::JRA::Odds::Quinella
  TABLE_COLUMN_SIZE = 8

  def initialize(first_race_card_id:, second_race_card_id:, odds:, crawled_at:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds = odds
    @crawled_at = crawled_at

    freeze
  end

  def save!
    JRA::Quinella.create!(
      first_jra_race_card_id: @first_race_card_id,
      second_jra_race_card_id: @second_race_card_id,
      odds: @odds,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)

  end
end
