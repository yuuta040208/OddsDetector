# frozen_string_literal: true

require 'open-uri'

class Crawler::JRA::Scraper
  HOST = 'https://www.keibalab.jp/'
  SLEEP_DURATION = 3

  class << self
    def daily(date = nil)
      date = date || Date.today
      top_page_document = Nokogiri::HTML(open(File.join(HOST, Crawler::JRA::TargetUrl::RACE_PATH, date.strftime('%Y%m%d'))))

      Crawler::JRA::TopPage.create_target_urls(top_page_document).each_with_index do |target_url, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, target_url.index)
        document = Nokogiri::HTML(open(url))

        ActiveRecord::Base.transaction do
          Crawler::JRA::Race.parse(document, target_url.race_id, date).save!
          Crawler::JRA::Horse.parse(document).each(&:save!)
          Crawler::JRA::RaceCard.parse(document, target_url.race_id).each(&:save!)
        end
      end
    end

    def publish(crawled_at = nil)
      Crawler::JRA::Publisher.new(crawled_at).execute
    end

    def single
      crawled_at = Time.current
      Crawler::JRA::Subscriber.single do |scraping_target, i|
        sleep(SLEEP_DURATION) if i.positive?

        url = File.join(HOST, scraping_target.url)
        document = Nokogiri::HTML(open(url))
        race = scraping_target.race

        ActiveRecord::Base.transaction do
          Crawler::JRA::Odds::Win.parse(document, race.id, crawled_at).each(&:save!)
          Crawler::JRA::Odds::Place.parse(document, race.id, crawled_at).each(&:save!)
        end
      end
    end
  end
end
