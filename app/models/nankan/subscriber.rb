# frozen_string_literal: true

class Nankan::Subscriber
  def initialize
    @scraping_targets = ScrapingTarget.all

    freeze
  end

  def execute
    scraping_targets = @scraping_targets.to_a
    @scraping_targets.each(&:destroy!)
    scraping_targets
  end

  def self.single
    ScrapingTarget.all.distinct.select(&:odds_single?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)
      scraping_target.destroy!
    end
  end

  def self.quinella
    ScrapingTarget.all.distinct.select(&:odds_quinella?).each.with_index do |scraping_target, i|
      yield(scraping_target, i)
      scraping_target.destroy!
    end
  end
end
