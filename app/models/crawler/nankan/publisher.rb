# frozen_string_literal: true

class Crawler::Nankan::Publisher
  def initialize(now = nil)
    @now = now || Time.current

    freeze
  end

  def execute
    target_races.each do |race|
      target_url = Crawler::Nankan::TargetUrl.new(race_id: race.id)
      Nankan::ScrapingTarget.create!(nankan_race_id: race.id, url: target_url.odds_single)
      Nankan::ScrapingTarget.create!(nankan_race_id: race.id, url: target_url.odds_quinella)
    end
  end

  def official
    unofficial_single_races.each do |race|
      Nankan::ScrapingTarget.create!(nankan_race_id: race.id, path: 'single')
    end
    unofficial_quinella_races.each do |race|
      Nankan::ScrapingTarget.create!(nankan_race_id: race.id, path: 'quinella')
    end
  end

  private

  def target_races
    Nankan::Race.where('hold_at = ? AND start_at > ?', @now.strftime('%Y-%m-%d'), @now).order(:start_at)
  end

  def unofficial_single_races
    Nankan::Race.where(hold_at: @now.strftime('%Y-%m-%d')).select(&:unofficial_by_win?)
  end

  def unofficial_quinella_races
    Nankan::Race.where(hold_at: @now.strftime('%Y-%m-%d')).select(&:unofficial_by_quinella?)
  end
end
