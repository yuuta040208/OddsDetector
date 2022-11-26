# frozen_string_literal: true

class JRA::RaceCard < ApplicationRecord
  belongs_to :race, foreign_key: :jra_race_id
  belongs_to :horse, foreign_key: :jra_horse_id
  has_many :wins, class_name: 'JRA::Win', foreign_key: :jra_race_card_id, dependent: :destroy
  has_many :places, class_name: 'JRA::Place', foreign_key: :jra_race_card_id, dependent: :destroy
  has_many :quinellas, class_name: 'JRA::Quinella', foreign_key: :first_jra_race_card_id, dependent: :destroy
  has_many :wides, class_name: 'JRA::Wide', foreign_key: :first_jra_race_card_id, dependent: :destroy
  has_one :official_win, -> { order(crawled_at: :desc) }, class_name: 'JRA::Win', foreign_key: :jra_race_card_id, dependent: :destroy
  has_one :official_place, -> { order(crawled_at: :desc) }, class_name: 'JRA::Place', foreign_key: :jra_race_card_id, dependent: :destroy

  delegate :name, to: :horse, prefix: true
  delegate :odds, to: :official_win, prefix: :win
  delegate :odds_min, :odds_max, to: :official_place, prefix: :place
end
