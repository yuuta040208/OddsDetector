# frozen_string_literal: true

class Nankan::RaceCard < ApplicationRecord
  belongs_to :race, foreign_key: :nankan_race_id
  belongs_to :horse, foreign_key: :nankan_horse_id
  has_many :wins, class_name: 'Nankan::Win', foreign_key: :nankan_race_card_id, dependent: :destroy
  has_many :places, class_name: 'Nankan::Place', foreign_key: :nankan_race_card_id, dependent: :destroy
  has_many :quinellas, class_name: 'Nankan::Quinella', foreign_key: :first_nankan_race_card_id, dependent: :destroy
  has_many :wides, class_name: 'Nankan::Wide', foreign_key: :first_nankan_race_card_id, dependent: :destroy
  has_many :scraping_targets, class_name: 'Nankan::ScrapingTarget', foreign_key: :nankan_race_card_id, dependent: :destroy
  has_one :official_win, -> { order(crawled_at: :desc) }, class_name: 'Nankan::Win', foreign_key: :nankan_race_card_id, dependent: :destroy
  has_one :official_place, -> { order(crawled_at: :desc) }, class_name: 'Nankan::Place', foreign_key: :nankan_race_card_id, dependent: :destroy

  delegate :name, to: :horse, prefix: true
  delegate :odds, to: :official_win, prefix: :win
  delegate :odds_min, :odds_max, to: :official_place, prefix: :place
end
