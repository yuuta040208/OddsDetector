# frozen_string_literal: true

class JRA::ScrapingTarget < ApplicationRecord
  belongs_to :race, required: false, foreign_key: :jra_race_id

  delegate :number, to: :race, prefix: true
end
