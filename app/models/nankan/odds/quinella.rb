# frozen_string_literal: true

class Nankan::Odds::Quinella
  def initialize(first_race_card_id:, second_race_card_id:, odds:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds = odds

    freeze
  end

  def save!
    Quinella.create!(
      first_race_card_id: @first_race_card_id,
      second_race_card_id: @second_race_card_id,
      odds: @odds
    )
  end

  def self.parse(document, race_id)
    race_cards = RaceCard.where(race_id: race_id)
    document.css('table[name=umafukuTB] td').map(&:text).each_slice(2).map do |combination, odds|
      next if combination.exclude?('-')

      first_horse_number, second_horse_number = combination.split('-').map(&:to_i)
      Nankan::Odds::Quinella.new(
        first_race_card_id: race_cards.find_by(horse_number: first_horse_number).id,
        second_race_card_id: race_cards.find_by(horse_number: second_horse_number).id,
        odds: odds.to_f
      )
    end.compact
  end
end