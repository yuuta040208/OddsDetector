# frozen_string_literal: true

class JRA::Wide < ApplicationRecord
  belongs_to :race_card, class_name: 'JRA::RaceCard', foreign_key: :first_jra_race_card_id
  belongs_to :second_race_card, class_name: 'JRA::RaceCard', foreign_key: :second_jra_race_card_id

  def odds
    ((odds_min + odds_max) / 2).round(1)
  end
end
