# frozen_string_literal: true

class Nankan::Odds::Win
  def initialize(race_card_id:, odds:)
    @race_card_id = race_card_id
    @odds = odds

    freeze
  end

  def save!
    Win.create!(
      race_card_id: @race_card_id,
      odds: @odds
    )
  end

  def self.parse(document, race_card_id)
    texts = document.css('table[name=tanfukuTB] td').map(&:text)
    Nankan::Odds::Win.new(
      race_card_id: race_card_id,
      odds: texts.third.to_f
    )
  end
end
