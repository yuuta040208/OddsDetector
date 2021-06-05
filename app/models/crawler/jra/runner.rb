# frozen_string_literal: true

require 'timers'

class Crawler::JRA::Runner
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
    puts Time.current + 9.hours
    Crawler::JRA::Scraper.publish
    Crawler::JRA::Scraper.single
    # Crawler::JRA::Scraper.quinella
    # Crawler::JRA::Scraper.wide
  end
end

