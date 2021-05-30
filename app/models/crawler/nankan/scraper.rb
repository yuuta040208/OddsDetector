# frozen_string_literal: true

require 'open-uri'

class Crawler::Nankan::Scraper
  HOST = 'https://www.nankankeiba.com/'
  SLEEP_DURATION = 3

  class << self
    def daily(date = nil)
      date = date || Date.today
      top_page_document = Nokogiri::HTML(open(HOST))

      Crawler::Nankan::TopPage.create_target_urls(top_page_document, date).each_with_index do |target_url, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, target_url.odds_single)
        document = Nokogiri::HTML(open(url))

        ActiveRecord::Base.transaction do
          race = Crawler::Nankan::Race.parse(document, url, date).save!
          Crawler::Nankan::Horse.parse(document).each(&:save!)
          Crawler::Nankan::RaceCard.parse(document, race.id).each(&:save!)
        end
      end
    end

    def publish(crawled_at = nil)
      Crawler::Nankan::Publisher.new(crawled_at).execute
      Crawler::Nankan::Publisher.new(crawled_at).official
    end

    def single
      Crawler::Nankan::Subscriber.single do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, scraping_target.url)
        document = Nokogiri::HTML(open(url))
        race = scraping_target.race

        now = Time.current
        crawled_at = race.start_at < now ? race.start_at : now

        ActiveRecord::Base.transaction do
          Crawler::Nankan::Odds::Win.parse(document, race.id, crawled_at).each(&:save!)
          Crawler::Nankan::Odds::Place.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    end

    def quinella
      Crawler::Nankan::Subscriber.quinella do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, scraping_target.url)
        document = Nokogiri::HTML(open(url))
        race = scraping_target.race

        now = Time.current
        crawled_at = race.start_at < now ? race.start_at : now

        ActiveRecord::Base.transaction do
          Crawler::Nankan::Odds::Quinella.parse(document, race.id, crawled_at).each(&:save!)
          Crawler::Nankan::Odds::Wide.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    end
  end
end
