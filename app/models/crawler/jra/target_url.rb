# frozen_string_literal: true

class Crawler::JRA::TargetUrl
  RACE_PATH = '/db/race/'

  attr_reader :race_id

  module Endpoint
    INDEX = '/umabashira.html'
    ODDS_SINGLE = '/odds.html'
  end

  def initialize(race_id:)
    @race_id = race_id

    freeze
  end

  def index
    File.join(RACE_PATH, @race_id.to_s, Endpoint::INDEX)
  end

  def odds_single
    File.join(RACE_PATH, @race_id.to_s, Endpoint::ODDS_SINGLE)
  end
end
