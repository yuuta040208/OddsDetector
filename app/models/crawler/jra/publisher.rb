# frozen_string_literal: true

class Crawler::JRA::Publisher
  def initialize(now = nil)
    @now = now || Time.current

    freeze
  end

  def execute
    target_races.each do |race|
      target_url = Crawler::JRA::TargetUrl.new(race_id: race.id)
      JRA::ScrapingTarget.create!(jra_race_id: race.id, url: target_url.odds_single)
      # JRA::ScrapingTarget.create!(jra_race_id: race.id, url: target_url.odds_quinella)
    end
  end

  private

  def target_races
    JRA::Race.where('hold_at = ? AND start_at > ?', @now.strftime('%Y-%m-%d'), @now).order(:start_at)
  end
end
