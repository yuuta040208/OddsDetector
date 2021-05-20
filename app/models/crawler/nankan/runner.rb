# frozen_string_literal: true

require 'timers'

class Crawler::Nankan::Runner
  def initialize
    Crawler::Nankan::Crawler.daily
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
    Crawler::Nankan::Crawler.publish
    Crawler::Nankan::Crawler.subscribe
  end
end

