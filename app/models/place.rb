# frozen_string_literal: true

class Place < ApplicationRecord
  belongs_to :race_card

  def odds
    ((odds_min + odds_max) / 2).round(1)
  end
end
