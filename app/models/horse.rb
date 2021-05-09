# frozen_string_literal: true

class Horse < ApplicationRecord
  has_many :race_cards
  has_many :races, through: :race_cards
end
