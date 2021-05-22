# frozen_string_literal: true

class Crawler::JRA::Race
  extend Trimmable

  def initialize(id:, name:, number:, course:, hold_at:, start_at:, description:)
    @id = id
    @name = name
    @number = number
    @course = course
    @hold_at = hold_at
    @start_at = start_at
    @description = description

    freeze
  end

  def save!
    JRA::Race.find_or_create_by!(id: @id, name: @name, number: @number, course: @course, hold_at: @hold_at, start_at: @start_at, description: @description)
  end

  def self.parse(document, race_id, date)
    new(
      id: race_id,
      name: document.css('div.RaceName').text.strip,
      number: document.css('span.RaceNum').text.to_i,
      course: document.css('div.RaceData01').text.split('/').last.strip,
      hold_at: date,
      start_at: Time.parse(document.css('div.RaceData01').text.split('/').first.strip),
      description: document.css('div.RaceData02').text.split("\n").select(&:present?)[0..2].join
    )
  end
end
