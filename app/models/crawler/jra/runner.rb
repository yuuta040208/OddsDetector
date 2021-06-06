# frozen_string_literal: true

require 'timers'

class Crawler::JRA::Runner
  class ScrapingTargetNotExistError < StandardError; end

  def initialize(initialization = true)
    Crawler::JRA::Scraper.daily if initialization
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
    Crawler::JRA::Scraper.publish

    if JRA::ScrapingTarget.all.count > 0
      Crawler::JRA::Scraper.single
      # Crawler::JRA::Scraper.quinella
      # Crawler::JRA::Scraper.wide
    else
      raise ScrapingTargetNotExistError
    end
  end
end

