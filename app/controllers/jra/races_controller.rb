# frozen_string_literal: true

class JRA::RacesController < ApplicationController
  def index
    @date_races = JRA::DateRace.all
  end

  def show
    @race = JRA::Race.find(params[:id])
    @horses = @race.horses
  end
end
