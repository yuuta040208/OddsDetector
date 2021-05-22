# frozen_string_literal: true

class JRA::Race < ApplicationRecord
  has_many :race_cards, class_name: 'JRA::RaceCard', foreign_key: :jra_race_id
  has_many :horses, through: :race_cards
end
