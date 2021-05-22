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
    document.css('tr.HorseList').map do |tr|
      Crawler::JRA::RaceCard.new(
        race_id: race_id,
        horse_id: JRA::Horse.find_by!(name: tr.css('td:nth-child(4)').text.strip).id,
        bracket_number: tr.css('td:nth-child(1)').text.to_i,
        horse_number: tr.css('td:nth-child(2)').text.to_i
      )
    end
  end
end
