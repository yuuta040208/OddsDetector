# frozen_string_literal: true

class Race < ApplicationRecord
  has_many :race_cards
  has_many :horses, through: :race_cards
end
