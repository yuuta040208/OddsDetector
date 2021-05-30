# frozen_string_literal: true

class JRA::RaceCard < ApplicationRecord
  belongs_to :race, foreign_key: :jra_race_id
  belongs_to :horse, foreign_key: :jra_horse_id
  has_many :wins, class_name: 'JRA::Win', foreign_key: :jra_race_card_id
  has_many :places, class_name: 'JRA::Place', foreign_key: :jra_race_card_id
  has_many :quinellas, class_name: 'JRA::Quinella', foreign_key: :first_jra_race_card_id
  has_many :wides, class_name: 'JRA::Wide', foreign_key: :first_jra_race_card_id

  delegate :name, to: :horse, prefix: true
end
