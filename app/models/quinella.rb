# frozen_string_literal: true

class Quinella < ApplicationRecord
  belongs_to :race_card, class_name: 'RaceCard', foreign_key: 'first_race_card_id'
  belongs_to :second_race_card, class_name: 'RaceCard', foreign_key: 'second_race_card_id'
end
