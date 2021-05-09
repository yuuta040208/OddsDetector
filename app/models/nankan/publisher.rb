# frozen_string_literal: true

class Nankan::Publisher
  def initialize(now = nil)
    @now = now || Time.current

    freeze
  end

  def execute
    target_races.map { |race| Nankan::TargetUrl.new(race_id: race.id) }.each do |target_url|
      RaceCard.where(race_id: target_url.race_id).each do |race_card|
        ScrapingTarget.create!(race_card_id: race_card.id, url: target_url.search(race_card.horse_number))
      end
    end
  end

  private

  def target_races
    Race.where('hold_at = ? AND start_at > ?', @now.strftime('%Y-%m-%d'), @now).order(:start_at)
  end
end
