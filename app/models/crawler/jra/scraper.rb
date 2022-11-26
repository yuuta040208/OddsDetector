# frozen_string_literal: true

require 'open-uri'

class Crawler::JRA::Scraper
  HOST = 'https://jra.jp/'

  SLEEP_DURATION = 3

  class << self
    # 1日に1回実行すれば良いやつ
    # レース情報を収集する
    def daily(date = nil)
      date = date || Date.today
      @session = Crawler::JRA::Session.new

      Crawler::JRA::Scenario.daily(@session, HOST, date) do |document|
        sleep(SLEEP_DURATION)

        ActiveRecord::Base.transaction do
          race = Crawler::JRA::Race.parse(document, date).save!
          Crawler::JRA::Horse.parse(document).each(&:save!)
          Crawler::JRA::RaceCard.parse(document, race.id).each(&:save!)
        end
      end
    end
  end
end
