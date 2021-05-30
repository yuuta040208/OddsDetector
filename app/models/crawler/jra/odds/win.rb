# frozen_string_literal: true

class Crawler::JRA::Odds::Win
  def initialize(race_card_id:, odds:, crawled_at:)
    @race_card_id = race_card_id
    @odds = odds
    @crawled_at = crawled_at

    freeze
  end

  def save!
    JRA::Win.create!(
      jra_race_card_id: @race_card_id,
      odds: @odds,
      crawled_at: @crawled_at,
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_card_hash = JRA::RaceCard.where(jra_race_id: race_id).group_by(&:horse_number)
    document.css('td.odds_tan').map(&:text).map.with_index(1) do |odds, horse_number|
      Crawler::JRA::Odds::Win.new(
        race_card_id: race_card_hash[horse_number].first.id,
        odds: odds.to_f,
        crawled_at: crawled_at
      )
    end
  end
end
