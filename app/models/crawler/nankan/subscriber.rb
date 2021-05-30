# frozen_string_literal: true

class Crawler::Nankan::Subscriber
  def self.single
    Nankan::ScrapingTarget.all.distinct.select(&:odds_single?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)

      scraping_target.destroy!
    end
  end

  def self.quinella
    Nankan::ScrapingTarget.all.distinct.select(&:odds_quinella?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)

      scraping_target.destroy!
    end
  end
end
