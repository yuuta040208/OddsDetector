# frozen_string_literal: true

class Nankan::Odds::Place
  def initialize(race_card_id:, odds_min:, odds_max:, crawled_at:)
    @race_card_id = race_card_id
    @odds_min = odds_min
    @odds_max = odds_max
    @crawled_at = crawled_at

    freeze
  end

  def save!
    Place.create!(
      race_card_id: @race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max,
      crawled_at: @crawled_at
    )
  end

  def self.parse(document, race_card_id, crawled_at)
    texts = document.css('table[name=tanfukuTB] td').map(&:text)
    Nankan::Odds::Place.new(
      race_card_id: race_card_id,
      odds_min: texts.fourth.split('-').map(&:strip).map(&:to_f).first,
      odds_max: texts.fourth.split('-').map(&:strip).map(&:to_f).second,
      crawled_at: crawled_at
    )
  end
end
