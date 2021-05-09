# frozen_string_literal: true

class Nankan::Odds::Place
  def initialize(race_card_id:, odds_min:, odds_max:)
    @race_card_id = race_card_id
    @odds_min = odds_min
    @odds_max = odds_max

    freeze
  end

  def save!
    Place.create!(
      race_card_id: @race_card_id,
      odds_min: @odds_min,
      odds_max: @odds_max
    )
  end

  def self.parse(document, race_card_id)
    texts = document.css('table[name=tanfukuTB] td').map(&:text)
    Nankan::Odds::Place.new(
      race_card_id: race_card_id,
      odds_min: texts.fourth.split('-').map(&:strip).map(&:to_f).first,
      odds_max: texts.fourth.split('-').map(&:strip).map(&:to_f).second
    )
  end
end
