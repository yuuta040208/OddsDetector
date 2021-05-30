# frozen_string_literal: true

json.data do
  json.array! @race_cards do |race_card|
    json.umaban race_card.horse_number
    json.odds race_card.win_odds
  end
end

json.datetime @crawled_at.strftime('%Y-%m-%d %H:%M:%S')
