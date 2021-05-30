# frozen_string_literal: true

json.data do
  json.array! @race_cards do |race_card|
    json.umaban race_card.horse_number
    json.odds_min race_card.place_odds_min
    json.odds_max race_card.place_odds_max
  end
end

json.datetime @crawled_at.strftime('%Y-%m-%d %H:%M:%S')
