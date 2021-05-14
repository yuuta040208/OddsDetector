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
    @race_cards = Race.find(params[:id]).race_cards.eager_load(:wins).order(:horse_number, crawled_at: :desc)
    @crawled_ats = @race_cards.pluck(:crawled_at).uniq.map { |time| time + 9.hours }
  end

  def odds_place
    @race_cards = Race.find(params[:id]).race_cards.preload(:places).order(:horse_number)
  end
end
