# frozen_string_literal: true

json.wins do
  json.array! @race_cards do |race_card|
    json.horse_number race_card.horse_number
    json.odds race_card.wins.pluck(:odds)
  end
end

json.crawled_at do
  json.array! @crawled_ats
end