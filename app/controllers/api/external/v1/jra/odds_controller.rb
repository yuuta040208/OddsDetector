# frozen_string_literal: true

class Api::External::V1::JRA::OddsController < Api::External::V1::ApplicationController
  def win
    race = JRA::Race.find_by!(description: params[:description], number: params[:number])
    @race_cards = race.race_cards.preload(:official_win)
    @crawled_at = @race_cards.map(&:official_win).map(&:crawled_at).first + 9.hours
  end

  def place
    race = JRA::Race.find_by!(description: params[:description], number: params[:number])
    @race_cards = race.race_cards.preload(:official_place)
    @crawled_at = @race_cards.map(&:official_place).map(&:crawled_at).first + 9.hours
  end

  def quinella

  end

  def wide

  end
end
