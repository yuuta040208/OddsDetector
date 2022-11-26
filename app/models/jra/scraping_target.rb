# frozen_string_literal: true

class JRA::ScrapingTarget < ApplicationRecord
  belongs_to :race, required: false, foreign_key: :jra_race_id

  delegate :id, :number, :description, :start_at, to: :race, prefix: true

  scope :recently, -> { eager_load(:race).merge(JRA::Race.order(:number)) }
end
