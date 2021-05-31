# frozen_string_literal: true

class Crawler::Nankan::Odds::Place
  def initialize(race_card_id:, odds_min:, odds_max:, crawled_at:)
    @race_card_id = race_card_id
    @odds_min = odds_min
    @odds_max = odds_max
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Nankan::Place.create!(
      nankan_race_card_id: @race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_card_hash = Nankan::RaceCard.where(nankan_race_id: race_id).group_by(&:horse_number)
    document.css('table[summary=単勝・複勝] td:nth-child(5)').map(&:text).map { |text| text.chop.strip }.map.with_index(1) do |odds, horse_number|
      odds = odds.split('-').map(&:strip)
      Crawler::Nankan::Odds::Place.new(
        race_card_id: race_card_hash[horse_number].first.id,
        odds_min: odds.first.to_f,
        odds_max: odds.last.to_f,
        crawled_at: crawled_at
      )
    end
  end
end
