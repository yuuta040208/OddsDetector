# frozen_string_literal: true

class Nankan::RacesController < ApplicationController
  def index
    @date_races = Kaminari.paginate_array(Nankan::DateRace.all).page(params[:page]).per(1)
  end

  def show
    @race = Nankan::Race.find(params[:id])
    @horses = @race.horses
  end
end
