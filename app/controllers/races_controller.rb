# frozen_string_literal: true

class RacesController < ApplicationController
  def index
    @races = Race.all.order(hold_at: :desc).order(:number).page(params[:page])
  end

  def show
    @race = Race.find(params[:id])
    @horses = @race.horses
  end
end
