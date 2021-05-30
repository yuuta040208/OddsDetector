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
    bracket_number = 1
    document.css('table.basic.narrow-xy.tanpuku tr').map.with_index do |tr, horse_number|
      next if horse_number.zero?

      bracket_number = tr.css('td.waku > img').first.attributes['alt'].value.delete('^0-9').to_i if tr.css('td.waku').present?
      Crawler::JRA::RaceCard.new(
        race_id: race_id,
        horse_id: JRA::Horse.find_by!(name: tr.css('td.horse > a').text).id,
        bracket_number: bracket_number,
        horse_number: horse_number
      )
    end.compact
  end
end
