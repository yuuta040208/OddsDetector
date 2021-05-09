# frozen_string_literal: true

class Nankan::TargetUrl
  attr_reader :race_id

  def initialize(race_id:)
    @race_id = race_id

    freeze
  end

  def odds
    "/odds/#{@race_id}01.do"
  end

  def search(horse_number)
    "/odds_uma/#{@race_id}#{horse_number.to_s.rjust(2, '0')}.do"
  end
end
