# frozen_string_literal: true

class RacesController < ApplicationController
  def index
    @races = Nankan::Race.all.order(hold_at: :desc).order(:number).page(params[:page])
  end

  def show
    @race = Nankan::Race.find(params[:id])
    @horses = @race.horses
  end
end
