# frozen_string_literal: true

class JRA::Horse < ApplicationRecord
  has_many :race_cards, class_name: 'JRA::RaceCard', foreign_key: :jra_horse_id
  has_many :races, through: :race_cards
end
