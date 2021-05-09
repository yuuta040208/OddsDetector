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
end
