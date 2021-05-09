# frozen_string_literal: true

class RacesController < ApplicationController
  def index
    @races = Race.all
  end

  def show
    @race = Race.find(params[:id])
    @horses = @race.horses
  end
end
