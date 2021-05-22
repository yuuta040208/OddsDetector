# frozen_string_literal: true

class JRA::Win < ApplicationRecord
  belongs_to :race_card, foreign_key: :jra_race_card_id
end
