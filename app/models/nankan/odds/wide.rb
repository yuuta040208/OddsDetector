# frozen_string_literal: true

class Nankan::Odds::Wide
  def initialize(first_race_card_id:, second_race_card_id:, odds_min:, odds_max:, crawled_at:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds_min = odds_min
    @odds_max = odds_max
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Wide.create!(
      first_race_card_id: @first_race_card_id,
      second_race_card_id: @second_race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_cards = RaceCard.where(race_id: race_id)
    document.css('table[name=wideTB] td').map(&:text).each_slice(2).map do |combination, odds|
      next if combination.exclude?('-')

      first_horse_number, second_horse_number = combination.split('-').map(&:to_i)
      odds_min, odds_max = odds.split('-').map(&:strip).map(&:to_f)
      Nankan::Odds::Wide.new(
        first_race_card_id: race_cards.find_by(horse_number: first_horse_number).id,
        second_race_card_id: race_cards.find_by(horse_number: second_horse_number).id,
        odds_min: odds_min,
        odds_max: odds_max,
        crawled_at: crawled_at
      )
    end.compact
  end
end
