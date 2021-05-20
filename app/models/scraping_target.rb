# frozen_string_literal: true

class ScrapingTarget < ApplicationRecord
  belongs_to :race, required: false
  belongs_to :race_card, required: false

  def odds_single?
    url.end_with?(Nankan::TargetUrl::Endpoint::ODDS_SINGLE)
  end

  def odds_quinella?
    url.end_with?(Nankan::TargetUrl::Endpoint::ODDS_QUINELLA)
  end
end
