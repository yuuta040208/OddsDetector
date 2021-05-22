# frozen_string_literal: true

class JRA::ScrapingTarget < ApplicationRecord
  belongs_to :race, required: false, foreign_key: :jra_race_id
  belongs_to :race_card, required: false, foreign_key: :jra_race_card_id

  def odds_single?
    url.end_with?(Crawler::JRA::TargetUrl::Endpoint::ODDS_SINGLE)
  end

  def odds_quinella?
    url.end_with?(Crawler::JRA::TargetUrl::Endpoint::ODDS_QUINELLA)
  end
end
