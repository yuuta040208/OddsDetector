# frozen_string_literal: true

class Nankan::Race < ApplicationRecord
  has_many :race_cards, class_name: 'Nankan::RaceCard', foreign_key: :nankan_race_id
  has_many :horses, through: :race_cards

  def unofficial_by_win?
    latest = race_cards.eager_load(:wins).map(&:wins).flatten.max_by(&:crawled_at)
    return false if latest.blank?

    start_at > latest.crawled_at
  end

  def unofficial_by_quinella?
    latest = race_cards.eager_load(:quinellas).map(&:quinellas).flatten.max_by(&:crawled_at)
    return false if latest.blank?

    start_at > latest.crawled_at
  end
end
