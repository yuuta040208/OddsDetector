# frozen_string_literal: true

class Crawler::Nankan::Horse
  def initialize(id:, name:)
    @id = id
    @name = name

    freeze
  end

  def save!
    Nankan::Horse.find_or_create_by!(id: @id, name: @name)
  end

  def self.parse(document)
    document.css('#contents950 > div.twoColEq_L > table a').map do |element|
      Crawler::Nankan::Horse.new(
        id: element.attributes['href'].value.split('/').last.to_i,
        name: element.text
      )
    end
  end
end
