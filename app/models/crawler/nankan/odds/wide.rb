# frozen_string_literal: true

class Crawler::Nankan::Odds::Wide
  TABLE_COLUMN_SIZE = 8

  def initialize(first_race_card_id:, second_race_card_id:, odds_min:, odds_max:, crawled_at:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds_min = odds_min
    @odds_max = odds_max
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Nankan::Wide.create!(
      first_nankan_race_card_id: @first_race_card_id,
      second_nankan_race_card_id: @second_race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    wides = []
    reversed_odds_list = []
    horse_count = Nankan::Race.find(race_id).horses.size
    race_card_hash = Nankan::RaceCard.where(nankan_race_id: race_id).group_by(&:horse_number)

    odds_list = document.css('table[summary=odds]')[1].css('tr').map { |tr| tr.css('td.al-right').map(&:text) }.select(&:present?)
    odds_list.each.with_index(1) do |array, i|
      reversed_odds = []
      array.each.with_index do |odds, j|
        if i + j + 1 > horse_count
          reversed_odds << odds
          next
        end

        wides << Crawler::Nankan::Odds::Wide.new(
          first_race_card_id: race_card_hash[j + 1].first.id,
          second_race_card_id: race_card_hash[i + j + 1].first.id,
          odds_min: odds.split('-').first.to_f,
          odds_max: odds.split('-').second.to_f,
          crawled_at: crawled_at
        )
      end

      reversed_odds_list << reversed_odds
    end


    reversed_odds_list.select(&:present?).map(&:reverse).each.with_index do |array, i|
      array.each_with_index do |odds, j|
        wides << Crawler::Nankan::Odds::Wide.new(
          first_race_card_id: race_card_hash[j + TABLE_COLUMN_SIZE + 1].first.id,
          second_race_card_id: race_card_hash[i + TABLE_COLUMN_SIZE + 2].first.id,
          odds_min: odds.split('-').first.to_f,
          odds_max: odds.split('-').second.to_f,
          crawled_at: crawled_at
        )
      end
    end

    wides
  end
end
