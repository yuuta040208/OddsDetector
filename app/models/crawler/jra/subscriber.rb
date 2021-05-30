# frozen_string_literal: true

class Crawler::JRA::Subscriber
  def self.single
    JRA::ScrapingTarget.eager_load(:race).distinct.where(path: 'single').order('jra_races.number').group_by { |a| a.race.description }.each do |description, scraping_targets|
      scraping_targets.each do |scraping_target|
        yield(description, scraping_target)

        scraping_target.destroy!
      end
    end
  end

  def self.quinella
    JRA::ScrapingTarget.eager_load(:race).distinct.where(path: 'quinella').order('jra_races.number').group_by { |a| a.race.description }.each do |description, scraping_targets|
      scraping_targets.each do |scraping_target|
        yield(description, scraping_target)

        scraping_target.destroy!
      end
    end
  end

  def self.wide
    JRA::ScrapingTarget.eager_load(:race).distinct.where(path: 'wide').order('jra_races.number').group_by { |a| a.race.description }.each do |description, scraping_targets|
      scraping_targets.each do |scraping_target|
        yield(description, scraping_target)

        scraping_target.destroy!
      end
    end
  end
end
