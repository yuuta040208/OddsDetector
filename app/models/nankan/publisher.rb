# frozen_string_literal: true

class Nankan::Publisher
  def initialize(now = nil)
    @now = now || Time.current

    freeze
  end

  def execute
    target_races.each do |race|
      target_url = Nankan::TargetUrl.new(race_id: race.id)
      ScrapingTarget.create!(race_id: race.id, url: target_url.odds_single)
      ScrapingTarget.create!(race_id: race.id, url: target_url.odds_quinella)
    end
  end

  private

  def target_races
    Race.where('hold_at = ? AND start_at > ?', @now.strftime('%Y-%m-%d'), @now).order(:start_at)
  end
end
