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
    @race_cards = Race.find(params[:id]).race_cards.preload(:wins).order(:horse_number)
  end

  def odds_place
    @race_cards = Race.find(params[:id]).race_cards.preload(:places).order(:horse_number)
  end
end
