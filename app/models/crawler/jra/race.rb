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
      name: document.css('h1.raceTitle').text.strip,
      number: document.css('div.icoRacedata').text.to_i,
      course: document.css('ul.classCourseSyokin li:nth-child(2)').text.split(/[[:space:]]/).first,
      hold_at: date,
      start_at: Time.parse(document.css('ul.classCourseSyokin li:nth-child(2)').text.split(/[[:space:]]/).last),
      description: document.css('p[itemprop=about]').text.gsub("\n", ' ')
    )
  end
end
