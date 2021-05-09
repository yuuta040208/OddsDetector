# frozen_string_literal: true

json.array! @race_cards do |race_card|
  json.horse_number race_card.horse_number
  json.wins do
    json.odds race_card.wins.pluck(:odds)
    json.time race_card.wins.pluck(:created_at)
  end
end

