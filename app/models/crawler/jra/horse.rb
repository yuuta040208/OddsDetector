# frozen_string_literal: true

class Crawler::JRA::Horse
  def initialize(id:, name:)
    @id = id
    @name = name

    freeze
  end

  def save!
    JRA::Horse.find_or_create_by!(id: @id, name: @name)
  end

  def self.parse(document)
    document.css('span.HorseName > a').map do |element|
      Crawler::JRA::Horse.new(
        id: element.attributes['href'].value.split('/').last.to_i,
        name: element.text
      )
    end
  end
end
