# frozen_string_literal: true

class Crawler::JRA::TargetUrl
  RACE_PATH = '/race/shutuba.html'
  ODDS_PATH = '/odds/index.html'

  attr_reader :race_id

  module Endpoint
    RACE = 'rf=race_list'
    ODDS_SINGLE = 'rf=shutuba_submenu'
  end

  def initialize(race_id:)
    @race_id = race_id

    freeze
  end

  # https://race.netkeiba.com/race/shutuba.html?race_id=202105021001&rf=race_list
  def race
    "#{RACE_PATH}?race_id=#{@race_id}&#{Endpoint::RACE}"
  end

  # https://race.netkeiba.com/odds/index.html?type=b1&race_id=202105021001&rf=shutuba_submenu
  def odds_single
    "#{ODDS_PATH}?type=b1&race_id=#{@race_id}&#{Endpoint::ODDS_SINGLE}"
  end
end
