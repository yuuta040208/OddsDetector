# frozen_string_literal: true

class Crawler::JRA::Horse
  def initialize(name:)
    @name = name

    freeze
  end

  def save!
    JRA::Horse.find_or_create_by!(name: @name)
  end

  def self.parse(document)
    document.css('td.horse > a').map do |element|
      Crawler::JRA::Horse.new(
        name: element.text
      )
    end
  end
end
