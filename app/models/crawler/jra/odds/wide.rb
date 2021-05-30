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
    document.css('table.wide').map do |table|
      first_horse_number = table.css('caption').text.to_i
      table.css('tr').map do |tr|
        second_horse_number = tr.css('th').text.to_i
        odds = tr.css('td').text.split('-').map(&:to_f)
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
