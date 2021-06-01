# frozen_string_literal: true

class Nankan::RacesController < ApplicationController
  def index
    @date_races = Nankan::DateRace.all
  end

  def show
    @race = Nankan::Race.find(params[:id])
    @horses = @race.horses
  end
end
