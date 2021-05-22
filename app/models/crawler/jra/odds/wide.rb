# frozen_string_literal: true

class Crawler::JRA::Odds::Wide
  def initialize(first_race_card_id:, second_race_card_id:, odds_min:, odds_max:, crawled_at:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds_min = odds_min
    @odds_max = odds_max
    @crawled_at = crawled_at

    freeze
  end

  def save!
    JRA::Wide.create!(
      first_jra_race_card_id: @first_race_card_id,
      second_jra_race_card_id: @second_race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_card_hash = JRA::RaceCard.where(jra_race_id: race_id).group_by(&:horse_number)
    document.css('table.Odds_Table').map.with_index(1) do |table, first_horse_number|
      table.css('td:nth-child(2)').map { |td| td.text.strip.split("\n").map(&:to_f) }.each.with_index(1).reverse_each.map do |odds, second_horse_number|
        Crawler::JRA::Odds::Wide.new(
          first_race_card_id: race_card_hash[first_horse_number].first.id,
          second_race_card_id: race_card_hash[second_horse_number].first.id,
          odds_min: odds.first,
          odds_max: odds.last,
          crawled_at: crawled_at
        )
      end
    end.flatten
  end
end
