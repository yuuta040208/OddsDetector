# frozen_string_literal: true

class Nankan::Horse < ApplicationRecord
  has_many :race_cards, class_name: 'Nankan::RaceCard', foreign_key: :nankan_horse_id
  has_many :races, through: :race_cards
end
