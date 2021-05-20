# frozen_string_literal: true

require 'open-uri'

class Nankan::Crawler
  HOST = 'https://www.nankankeiba.com/'
  SLEEP_DURATION = 3

  class << self
    def daily(date = nil)
      date = date || Date.today
      top_page_document = Nokogiri::HTML(open(HOST))

      Nankan::TopPage.create_target_urls(top_page_document, date).each_with_index do |target_url, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, target_url.odds_single)
        document = Nokogiri::HTML(open(url))

        race = Nankan::Race.parse(document, url, date).save!
        Nankan::Horse.parse(document).each(&:save!)
        Nankan::RaceCard.parse(document, race.id).each(&:save!)
      end
    end

    def publish(crawled_at = nil)
      Nankan::Publisher.new(crawled_at).execute
    end

    def single
      crawled_at = Time.current
      Nankan::Subscriber.single do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, scraping_target.url)
        document = Nokogiri::HTML(open(url))
        race = scraping_target.race

        Win.transaction do
          Nankan::Odds::Win.parse(document, race.id, crawled_at).each(&:save!)
        end

        Place.transaction do
          Nankan::Odds::Place.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    end

    def quinella
      crawled_at = Time.current
      Nankan::Subscriber.quinella do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, scraping_target.url)
        document = Nokogiri::HTML(open(url))
        race = scraping_target.race

        Quinella.transaction do
          Nankan::Odds::Quinella.parse(document, race.id, crawled_at).each(&:save!)
        end

        Wide.transaction do
          Nankan::Odds::Wide.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    end
  end
end
