# frozen_string_literal: true

class Nankan::Odds::Quinella
  TABLE_COLUMN_SIZE = 8

  def initialize(first_race_card_id:, second_race_card_id:, odds:, crawled_at:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds = odds
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Quinella.create!(
      first_race_card_id: @first_race_card_id,
      second_race_card_id: @second_race_card_id,
      odds: @odds,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    quinellas = []
    reversed_odds_list = []
    horse_count = Race.find(race_id).horses.size
    race_card_hash = RaceCard.where(race_id: race_id).group_by(&:horse_number)

    odds_list = document.css('table[summary=odds]').first.css('tr').map { |tr| tr.css('td.al-right').map(&:text) }.select(&:present?)
    odds_list.each.with_index(1) do |array, i|
      reversed_odds = []
      array.each.with_index do |odds, j|
        if i + j + 1 > horse_count
          reversed_odds << odds
          next
        end

        quinellas << Nankan::Odds::Quinella.new(
          first_race_card_id: race_card_hash[j + 1].first.id,
          second_race_card_id: race_card_hash[i + j + 1].first.id,
          odds: odds.to_f,
          crawled_at: crawled_at
        )
      end

      reversed_odds_list << reversed_odds
    end


    reversed_odds_list.select(&:present?).map(&:reverse).each.with_index do |array, i|
      array.each_with_index do |odds, j|
        quinellas << Nankan::Odds::Quinella.new(
          first_race_card_id: race_card_hash[j + TABLE_COLUMN_SIZE + 1].first.id,
          second_race_card_id: race_card_hash[i + TABLE_COLUMN_SIZE + 2].first.id,
          odds: odds.to_f,
          crawled_at: crawled_at
        )
      end
    end

    quinellas
  end
end
