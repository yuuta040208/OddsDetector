# frozen_string_literal: true

json.array! @race_cards do |race_card|
  json.horse_number race_card.horse_number
  json.places do
    json.odds_min race_card.places.pluck(:odds_min)
    json.odds_max race_card.places.pluck(:odds_max)
    json.time race_card.places.pluck(:created_at)
  end
end

