# frozen_string_literal: true

class JRA::Quinella < ApplicationRecord
  belongs_to :race_card, class_name: 'JRA::RaceCard', foreign_key: :first_jra_race_card_id
  belongs_to :second_race_card, class_name: 'JRA::RaceCard', foreign_key: :second_jra_race_card_id
end
