# frozen_string_literal: true

class Crawler::JRA::RaceCard
  def initialize(race_id:, horse_id:, bracket_number:, horse_number:)
    @race_id = race_id
    @horse_id = horse_id
    @bracket_number = bracket_number
    @horse_number = horse_number

    freeze
  end

  def save!
    JRA::RaceCard.find_or_create_by!(jra_race_id: @race_id, jra_horse_id: @horse_id, bracket_number: @bracket_number, horse_number: @horse_number)
  end

  def self.parse(document, race_id)
    bracket_numbers = document.css('tr.wakuban:nth-child(1) td').map(&:text).select(&:present?).reverse.map(&:to_i)
    horse_names = document.css('a.tategaki.bamei').map(&:text).reverse

    bracket_numbers.map.with_index(1) do |bracket_number, horse_number|
      horse_id = JRA::Horse.find_by!(name: horse_names[horse_number]).id
      Crawler::JRA::RaceCard.new(
        race_id: race_id,
        horse_id: horse_id,
        bracket_number: bracket_number,
        horse_number: horse_number
      )
    end
  end
end
