# frozen_string_literal: true

class Nankan::Odds::Win
  def initialize(race_card_id:, odds:, crawled_at:)
    @race_card_id = race_card_id
    @odds = odds
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Win.create!(
      race_card_id: @race_card_id,
      odds: @odds,
      crawled_at: @crawled_at,
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_card_hash = RaceCard.where(race_id: race_id).group_by(&:horse_number)
    document.css('table[summary=単勝・複勝] td:nth-child(4)').map(&:text).map { |text| text.chop.strip.to_f }.map.with_index(1) do |odds, horse_number|
      Nankan::Odds::Win.new(
        race_card_id: race_card_hash[horse_number].first.id,
        odds: odds,
        crawled_at: crawled_at
      )
    end
  end
end
