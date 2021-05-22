# frozen_string_literal: true

class JRA::RaceCard < ApplicationRecord
  belongs_to :race, foreign_key: :jra_race_id
  belongs_to :horse, foreign_key: :jra_horse_id
  # has_many :wins, class_name: 'Nankan::Win', foreign_key: :nankan_race_card_id
  # has_many :places, class_name: 'Nankan::Place', foreign_key: :nankan_race_card_id
  # has_many :quinellas, class_name: 'Nankan::Quinella', foreign_key: :first_nankan_race_card_id
  # has_many :wides, class_name: 'Nankan::Wide', foreign_key: :first_nankan_race_card_id
  # has_many :scraping_targets, class_name: 'Nankan::ScrapingTarget', foreign_key: :nankan_race_card_id

  delegate :name, to: :horse, prefix: true
end