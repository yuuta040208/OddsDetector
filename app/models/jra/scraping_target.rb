# frozen_string_literal: true

class JRA::ScrapingTarget < ApplicationRecord
  belongs_to :race, required: false, foreign_key: :jra_race_id
  belongs_to :race_card, required: false, foreign_key: :jra_race_card_id

  def odds_single?
    url.include?(Crawler::JRA::TargetUrl::Type::ODDS_SINGLE)
  end

  def odds_quinella?
    url.include?(Crawler::JRA::TargetUrl::Type::ODDS_QUINELLA)
  end

  def odds_wide?
    url.include?(Crawler::JRA::TargetUrl::Type::ODDS_WIDE)
  end
end
