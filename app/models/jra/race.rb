# frozen_string_literal: true

class JRA::Race < ApplicationRecord
  has_many :race_cards, class_name: 'JRA::RaceCard', foreign_key: :jra_race_id
  has_many :horses, through: :race_cards

  def unofficial_by_win?
    latest = race_cards.preload(:wins).map(&:wins).flatten.max_by(&:crawled_at)
    return false if latest.blank?

    start_at > latest.crawled_at
  end

  def unofficial_by_quinella?
    latest = race_cards.preload(:quinellas).map(&:quinellas).flatten.max_by(&:crawled_at)
    return false if latest.blank?

    start_at > latest.crawled_at
  end

  def unofficial_by_wide?
    latest = race_cards.preload(:wides).map(&:wides).flatten.max_by(&:crawled_at)
    return false if latest.blank?

    start_at > latest.crawled_at
  end
end
