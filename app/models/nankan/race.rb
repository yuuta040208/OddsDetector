# frozen_string_literal: true

class Nankan::Race < ApplicationRecord
  has_many :race_cards, class_name: 'Nankan::RaceCard', foreign_key: :nankan_race_id
  has_many :horses, through: :race_cards
end
