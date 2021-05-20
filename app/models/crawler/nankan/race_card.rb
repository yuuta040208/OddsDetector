# frozen_string_literal: true

class Crawler::Nankan::RaceCard
  def initialize(race_id:, horse_id:, bracket_number:, horse_number:)
    @race_id = race_id
    @horse_id = horse_id
    @bracket_number = bracket_number
    @horse_number = horse_number

    freeze
  end

  def save!
    Nankan::RaceCard.find_or_create_by!(nankan_race_id: @race_id, nankan_horse_id: @horse_id, bracket_number: @bracket_number, horse_number: @horse_number)
  end

  def self.parse(document, race_id)
    document.css('#contents950 > div.twoColEq_L > table tr').map { |tr| tr.css('td').map(&:text).map(&:strip) }.select(&:present?).map do |texts|
      horse_id = Nankan::Horse.find_by(name: texts.third).id
      Crawler::Nankan::RaceCard.new(
        race_id: race_id,
        horse_id: horse_id,
        bracket_number: texts.first,
        horse_number: texts.second
      )
    end
  end
end
