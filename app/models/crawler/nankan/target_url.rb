# frozen_string_literal: true

class Crawler::Nankan::TargetUrl
  attr_reader :race_id

  module Endpoint
    ODDS_SINGLE = '01.do'
    ODDS_QUINELLA = '04.do'
  end

  def initialize(race_id:)
    @race_id = race_id

    freeze
  end

  def odds_single
    "/odds/#{@race_id}#{Endpoint::ODDS_SINGLE}"
  end

  def odds_quinella
    "/odds/#{@race_id}#{Endpoint::ODDS_QUINELLA}"
  end
end
