# frozen_string_literal: true

class Crawler::JRA::Publisher
  def initialize(now = nil)
    @now = now || Time.current

    freeze
  end

  # 未発走の全レースをpublishする
  def execute
    JRA::ScrapingTarget.transaction do
      target_races.each do |race|
        JRA::ScrapingTarget.find_or_create_by!(jra_race_id: race.id, path: 'single')
        JRA::ScrapingTarget.find_or_create_by!(jra_race_id: race.id, path: 'quinella')
        JRA::ScrapingTarget.find_or_create_by!(jra_race_id: race.id, path: 'wide')
      end
    end
  end

  # 確定オッズをまだ収集していないがすでに終わったレースをpublishする
  def official
    JRA::ScrapingTarget.transaction do
      unofficial_single_races.each do |race|
        JRA::ScrapingTarget.find_or_create_by!(jra_race_id: race.id, path: 'single')
      end
      unofficial_quinella_races.each do |race|
        JRA::ScrapingTarget.find_or_create_by!(jra_race_id: race.id, path: 'quinella')
      end
      unofficial_wide_races.each do |race|
        JRA::ScrapingTarget.find_or_create_by!(jra_race_id: race.id, path: 'wide')
      end
    end
  end

  private

  def target_races
    JRA::Race.where('hold_at = ? AND start_at > ?', @now, @now).order(:start_at)
  end

  def unofficial_single_races
    JRA::Race.where(hold_at: @now).select(&:unofficial_by_win?)
  end

  def unofficial_quinella_races
    JRA::Race.where(hold_at: @now).select(&:unofficial_by_quinella?)
  end

  def unofficial_wide_races
    JRA::Race.where(hold_at: @now).select(&:unofficial_by_wide?)
  end
end
