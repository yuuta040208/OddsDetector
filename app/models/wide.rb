# frozen_string_literal: true

class Wide < ApplicationRecord
  belongs_to :race_card, class_name: 'RaceCard', foreign_key: 'first_race_card_id'
  belongs_to :second_race_card, class_name: 'RaceCard', foreign_key: 'second_race_card_id'

  def odds
    ((odds_min + odds_max) / 2).round(1)
  end
end
