# frozen_string_literal: true

class Wide < ApplicationRecord
  belongs_to :race_card, class_name: 'RaceCard', foreign_key: 'first_race_card_id'
end
