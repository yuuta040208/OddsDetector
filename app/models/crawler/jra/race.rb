# frozen_string_literal: true

class Crawler::JRA::Race
  extend Trimmable

  def initialize(name:, number:, course:, hold_at:, start_at:, description:)
    @name = name
    @number = number
    @course = course
    @hold_at = hold_at
    @start_at = start_at
    @description = description

    freeze
  end

  def save!
    JRA::Race.find_or_create_by!(name: @name, number: @number, course: @course, hold_at: @hold_at, start_at: @start_at, description: @description)
  end

  def self.parse(document, date)
    new(
      name: document.css('span.race_name').text,
      number: document.css('div.race_number > img').first.attributes['alt'].value.to_i,
      course: document.css('div.cell.course').text.strip,
      hold_at: date,
      start_at: Time.parse("#{date.to_s} #{document.css('div.date_line > div.inner > div.cell.time > strong').text.gsub('時', ':').gsub('分', '')}"),
      description: document.css('div.cell.date').text.split(' ').last
    )
  end
end
