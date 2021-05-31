# frozen_string_literal: true

class Crawler::Nankan::Race
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
    Nankan::Race.find_or_create_by!(id: @id, name: @name, number: @number, course: @course, hold_at: @hold_at, start_at: @start_at, description: @description)
  end

  def self.parse(document, url, date)
    new(
      id: url.split('/').last.to_i.to_s[0..-3],
      name: trim(document.css('#race-data01-b > h3 > span').text.strip),
      number: document.css('#race-data01-b > p.bl-left.mR5.pT3 > img').first.attributes['alt'].value.to_i,
      course: document.css('#race-data01-a > a').text.strip,
      hold_at: date,
      start_at: Time.parse("#{document.css('#race-data01-a > strong').text} +0900"),
      description: document.css('#race-data01-a > span.tx-mid.tx-bold.tx-gray01').text.strip.gsub("\t", '')
    )
  end
end
