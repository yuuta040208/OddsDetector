# frozen_string_literal: true

class Nankan::Quinella < ApplicationRecord
  belongs_to :race_card, class_name: 'Nankan::RaceCard', foreign_key: :first_nankan_race_card_id
  belongs_to :second_race_card, class_name: 'Nankan::RaceCard', foreign_key: :second_nankan_race_card_id
end
