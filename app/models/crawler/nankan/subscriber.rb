# frozen_string_literal: true

class Crawler::Nankan::Subscriber
  def self.single
    Nankan::ScrapingTarget.all.select(:nankan_race_id, :url).distinct.select(&:odds_single?).each.with_index do |scraping_target, i|
      scraping_targets = Nankan::ScrapingTarget.where(url: scraping_target.url)
      yield(scraping_targets.first, i)

      scraping_targets.each(&:destroy!)
    end
  end

  def self.quinella
    Nankan::ScrapingTarget.all.select(:nankan_race_id, :url).distinct.select(&:odds_quinella?).each.with_index do |scraping_target, i|
      scraping_targets = Nankan::ScrapingTarget.where(url: scraping_target.url)
      yield(scraping_targets.first, i)

      scraping_targets.each(&:destroy!)
    end
  end
end
