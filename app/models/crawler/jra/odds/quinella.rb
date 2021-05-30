# frozen_string_literal: true

class Crawler::JRA::Odds::Quinella
  def initialize(first_race_card_id:, second_race_card_id:, odds:, crawled_at:)
    @first_race_card_id = first_race_card_id
    @second_race_card_id = second_race_card_id
    @odds = odds
    @crawled_at = crawled_at

    freeze
  end

  def save!
    JRA::Quinella.create!(
      first_jra_race_card_id: @first_race_card_id,
      second_jra_race_card_id: @second_race_card_id,
      odds: @odds,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_id, crawled_at)
    race_card_hash = JRA::RaceCard.where(jra_race_id: race_id).group_by(&:horse_number)
    document.css('table.umaren').map do |table|
      first_horse_number = table.css('caption').text.to_i
      table.css('tr').map do |tr|
        second_horse_number = tr.css('th').text.to_i
        odds = tr.css('td').text.to_f
        Crawler::JRA::Odds::Quinella.new(
          first_race_card_id: race_card_hash[first_horse_number].first.id,
          second_race_card_id: race_card_hash[second_horse_number].first.id,
          odds: odds.to_f,
          crawled_at: crawled_at
        )
      end
    end.flatten
  end
end
