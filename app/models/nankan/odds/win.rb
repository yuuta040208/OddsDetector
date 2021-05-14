# frozen_string_literal: true

class Nankan::Odds::Win
  def initialize(race_card_id:, odds:, crawled_at:)
    @race_card_id = race_card_id
    @odds = odds
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Win.create!(
      race_card_id: @race_card_id,
      odds: @odds,
      crawled_at: @crawled_at,
    )
  end

  def self.parse(document, race_card_id, crawled_at)
    texts = document.css('table[name=tanfukuTB] td').map(&:text)
    Nankan::Odds::Win.new(
      race_card_id: race_card_id,
      odds: texts.third.to_f,
      crawled_at: crawled_at
    )
  end
end
