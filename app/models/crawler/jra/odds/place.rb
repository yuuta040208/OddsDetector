# frozen_string_literal: true

class Crawler::JRA::Odds::Place
  def initialize(race_card_id:, odds_min:, odds_max:, crawled_at:)
    @race_card_id = race_card_id
    @odds_min = odds_min
    @odds_max = odds_max
    @crawled_at = crawled_at

    freeze
  end

  def save!
    JRA::Place.create!(
      jra_race_card_id: @race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_card_hash = JRA::RaceCard.where(jra_race_id: race_id).group_by(&:horse_number)
    document.css('div#odds_fuku_block td.Odds.Popular').map.with_index(1) do |td, horse_number|
      Crawler::JRA::Odds::Place.new(
        race_card_id: race_card_hash[horse_number].first.id,
        odds_min: td.text.split(' - ').first.to_f,
        odds_max: td.text.split(' - ').last.to_f,
        crawled_at: crawled_at
      )
    end
  end
end
