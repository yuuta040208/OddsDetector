# frozen_string_literal: true

require 'timers'

class Crawler::Nankan::Runner
  class ScrapingTargetNotExistError < StandardError; end

  def initialize(initialization = true)
    Crawler::Nankan::Scraper.daily if initialization
  end

  def execute
    crawl

    timers = Timers::Group.new
    timers.every(60 * 5) do
      crawl
    end

    loop { timers.wait }
  end

  private

  def crawl
    Crawler::Nankan::Scraper.publish

    if Nankan::ScrapingTarget.all.count > 0
      Crawler::Nankan::Scraper.single
      # Crawler::Nankan::Scraper.quinella
    else
      raise ScrapingTargetNotExistError
    end
  end
end

