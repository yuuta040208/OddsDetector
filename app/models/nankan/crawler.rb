# frozen_string_literal: true

require 'open-uri'

class Nankan::Crawler
  HOST = 'https://www.nankankeiba.com/'

  class << self
    def daily(date = nil)
      date = date || Date.today
      top_page_document = Nokogiri::HTML(open(HOST))

      delayed_each(Nankan::TopPage.create_target_urls(top_page_document, date)) do |target_url|
        url = File.join(HOST, target_url.odds)
        document = Nokogiri::HTML(open(url))

        race = Nankan::Race.parse(document, url, date).save!
        Nankan::Horse.parse(document).each(&:save!)
        Nankan::RaceCard.parse(document, race.id).each(&:save!)
      end
    end

    def odds
      delayed_each(Nankan::Subscriber.new.execute) do |scraping_target|
        url = File.join(HOST, scraping_target.url)
        document = Nokogiri::HTML(open(url))
        race_card = scraping_target.race_card

        Nankan::Odds::Win.parse(document, race_card.id).save!
        Nankan::Odds::Place.parse(document, race_card.id).save!
        Nankan::Odds::Quinella.parse(document, race_card.race_id).each(&:save!)
        Nankan::Odds::Wide.parse(document, race_card.race_id).each(&:save!)
      end
    end

    private

    def delayed_each(enumerable, duration = 3)
      enumerable.each_with_index do |target, i|
        sleep(duration) if i.positive?
        yield(target)
      end
    end
  end
end
