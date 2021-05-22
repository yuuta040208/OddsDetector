# frozen_string_literal: true

class JRA::Place < ApplicationRecord
  belongs_to :race_card, foreign_key: :jra_race_card_id

  def odds
    ((odds_min + odds_max) / 2).round(1)
  end
end
