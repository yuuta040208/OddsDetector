# frozen_string_literal: true

class Api::V1::RacesController < Api::ApplicationController
  def index
    @races = Race.where(hold_at: Date.today)
  end

  def show
    @race = Race.find(params[:id])
  end

  def horses
    @race_cards = Race.find(params[:id]).race_cards
  end

  def odds_win
    @data = Win.eager_load(race_card: :horse).where(race_cards: { race_id: params[:id] }).order(crawled_at: :desc).order(:horse_number).group_by(&:crawled_at).map do |crawled_at, wins|
      hash = { crawled_at: crawled_at }
      hash[:horses] = wins.map do |win|
        { number: win.race_card.horse_number, name: win.race_card.horse_name, odds: win.odds }
      end
      hash
    end
  end

  def odds_place
    @race_cards = Race.find(params[:id]).race_cards.preload(:places).order(:horse_number)
  end
end
