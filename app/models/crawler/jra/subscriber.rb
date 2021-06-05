# frozen_string_literal: true

class Crawler::JRA::Subscriber
  def self.single
    JRA::ScrapingTarget.eager_load(:race).where(path: 'single').order('jra_races.number').group_by { |a| a.race.description }.each do |description, scraping_targets|
      scraping_targets.uniq(&:jra_race_id).each do |scraping_target|
        yield(description, scraping_target)

        JRA::ScrapingTarget.where(jra_race_id: scraping_target.jra_race_id, path: scraping_target.path).each(&:destroy!)
      end
    end
  end

  def self.quinella
    JRA::ScrapingTarget.eager_load(:race).where(path: 'quinella').order('jra_races.number').group_by { |a| a.race.description }.each do |description, scraping_targets|
      scraping_targets.uniq(&:jra_race_id).each do |scraping_target|
        yield(description, scraping_target)

        JRA::ScrapingTarget.where(jra_race_id: scraping_target.jra_race_id, path: scraping_target.path).each(&:destroy!)
      end
    end
  end

  def self.wide
    JRA::ScrapingTarget.eager_load(:race).where(path: 'wide').order('jra_races.number').group_by { |a| a.race.description }.each do |description, scraping_targets|
      scraping_targets.uniq(&:jra_race_id).each do |scraping_target|
        yield(description, scraping_target)

        JRA::ScrapingTarget.where(jra_race_id: scraping_target.jra_race_id, path: scraping_target.path).each(&:destroy!)
      end
    end
  end
end
