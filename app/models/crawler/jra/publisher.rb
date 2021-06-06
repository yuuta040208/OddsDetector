# frozen_string_literal: true

class Crawler::JRA::Publisher
  def initialize(now = nil)
    @now = now || Time.current

    freeze
  end

  def execute
    target_races.each do |race|
      JRA::ScrapingTarget.create!(jra_race_id: race.id, path: 'single')
      # JRA::ScrapingTarget.create!(jra_race_id: race.id, path: 'quinella')
      # JRA::ScrapingTarget.create!(jra_race_id: race.id, path: 'wide')
    end
  end

  def official
    unofficial_single_races.each do |race|
      JRA::ScrapingTarget.create!(jra_race_id: race.id, path: 'single')
    end
    # unofficial_quinella_races.each do |race|
    #   JRA::ScrapingTarget.create!(jra_race_id: race.id, path: 'quinella')
    # end
    # unofficial_wide_races.each do |race|
    #   JRA::ScrapingTarget.create!(jra_race_id: race.id, path: 'wide')
    # end
  end

  private

  def target_races
    JRA::Race.where('hold_at = ? AND start_at > ?', @now.strftime('%Y-%m-%d'), @now).order(:start_at)
  end

  def unofficial_single_races
    JRA::Race.where(hold_at: @now.strftime('%Y-%m-%d')).select(&:unofficial_by_win?)
  end

  def unofficial_quinella_races
    JRA::Race.where(hold_at: @now.strftime('%Y-%m-%d')).select(&:unofficial_by_quinella?)
  end

  def unofficial_wide_races
    JRA::Race.where(hold_at: @now.strftime('%Y-%m-%d')).select(&:unofficial_by_wide?)
  end
end
