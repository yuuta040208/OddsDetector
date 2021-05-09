# frozen_string_literal: true

class RaceCard < ApplicationRecord
  belongs_to :race
  belongs_to :horse
  has_many :wins
  has_many :places
  has_many :quinellas, class_name: 'Quinella', foreign_key: 'first_race_card_id'
  has_many :wides, class_name: 'Wide', foreign_key: 'first_race_card_id'
  has_many :scraping_targets
end
