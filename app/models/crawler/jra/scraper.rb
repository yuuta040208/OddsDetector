# frozen_string_literal: true

require 'open-uri'

class Crawler::JRA::Scraper
  HOST = 'https://jra.jp/'

  SLEEP_DURATION = 3

  class << self
    def daily(date = nil)
      date = date || Date.today
      session = Crawler::JRA::Session.new

      Crawler::JRA::Scenario.daily(session, HOST, date) do |document|
        sleep(SLEEP_DURATION)

        ActiveRecord::Base.transaction do
          race = Crawler::JRA::Race.parse(document, date).save!
          Crawler::JRA::Horse.parse(document).each(&:save!)
          Crawler::JRA::RaceCard.parse(document, race.id).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end

    def publish(crawled_at = nil)
      Crawler::JRA::Publisher.new(crawled_at).execute
      Crawler::JRA::Publisher.new(crawled_at).official
    end

    def single
      session = Crawler::JRA::Session.new

      Crawler::JRA::Scenario.single(session, HOST) do |document, race_id|
        sleep(SLEEP_DURATION)

        now = Time.current
        start_at = JRA::Race.find(race_id).start_at
        crawled_at = start_at < now ? start_at : now

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Win.parse(document, race_id, crawled_at).each(&:save!)
          Crawler::JRA::Odds::Place.parse(document, race_id, crawled_at).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end

    def quinella
      session = Crawler::JRA::Session.new

      Crawler::JRA::Scenario.quinella(session, HOST) do |document, race_id|
        sleep(SLEEP_DURATION)

        now = Time.current
        start_at = JRA::Race.find(race_id).start_at
        crawled_at = start_at < now ? start_at : now

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Quinella.parse(document, race_id, crawled_at).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end

    def wide
      session = Crawler::JRA::Session.new

      Crawler::JRA::Scenario.wide(session, HOST) do |document, race_id|
        sleep(SLEEP_DURATION)

        now = Time.current
        start_at = JRA::Race.find(race_id).start_at
        crawled_at = start_at < now ? start_at : now

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Wide.parse(document, race_id, crawled_at).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end
  end
end
