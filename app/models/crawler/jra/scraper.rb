# frozen_string_literal: true

require 'open-uri'

class Crawler::JRA::Scraper
  HOST = 'https://race.netkeiba.com/'
  SLEEP_DURATION = 3

  class << self
    def daily(date = nil)
      date = date || Date.today
      session = Crawler::JRA::Session.new
      session.visit(File.join(HOST, 'top/race_list.html'))
      top_page_document = Nokogiri::HTML(session.html)

      Crawler::JRA::TopPage.create_target_urls(top_page_document).each_with_index do |target_url, i|
        sleep(SLEEP_DURATION) if i.positive?

        session.visit(File.join(HOST, target_url.race))
        document = Nokogiri::HTML(session.html)

        ActiveRecord::Base.transaction do
          Crawler::JRA::Race.parse(document, target_url.race_id, date).save!
          Crawler::JRA::Horse.parse(document).each(&:save!)
          Crawler::JRA::RaceCard.parse(document, target_url.race_id).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end

    def publish(crawled_at = nil)
      Crawler::JRA::Publisher.new(crawled_at).execute
    end

    def single
      crawled_at = Time.current
      session = Crawler::JRA::Session.new
      Crawler::JRA::Subscriber.single do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        session.visit(File.join(HOST, scraping_target.url))
        document = Nokogiri::HTML(session.html)
        race = scraping_target.race

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Win.parse(document, race.id, crawled_at).each(&:save!)
          Crawler::JRA::Odds::Place.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end

    def quinella
      crawled_at = Time.current
      session = Crawler::JRA::Session.new
      Crawler::JRA::Subscriber.quinella do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        session.visit(File.join(HOST, scraping_target.url))
        document = Nokogiri::HTML(session.html)
        race = scraping_target.race

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Quinella.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end

    def wide
      crawled_at = Time.current
      session = Crawler::JRA::Session.new
      Crawler::JRA::Subscriber.wide do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        session.visit(File.join(HOST, scraping_target.url))
        document = Nokogiri::HTML(session.html)
        race = scraping_target.race

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Wide.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    ensure
      Capybara.current_session.driver.quit
    end
  end
end
