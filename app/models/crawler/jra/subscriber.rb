# frozen_string_literal: true

class Crawler::JRA::Subscriber
  def self.single
    JRA::ScrapingTarget.all.distinct.select(&:odds_single?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)
      scraping_target.destroy!
    end
  end

  def self.quinella
    JRA::ScrapingTarget.all.distinct.select(&:odds_quinella?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)
      scraping_target.destroy!
    end
  end

  def self.wide
    JRA::ScrapingTarget.all.distinct.select(&:odds_wide?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)
      scraping_target.destroy!
    end
  end
end
