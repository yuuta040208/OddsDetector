# frozen_string_literal: true

class Nankan::Win < ApplicationRecord
  belongs_to :race_card, foreign_key: :nankan_race_card_id
end
