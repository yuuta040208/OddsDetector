# frozen_string_literal: true

class JRA::RacesController < ApplicationController
  def index
    @date_races = Kaminari.paginate_array(JRA::DateRace.all).page(params[:page]).per(1)
  end

  def show
    @race = JRA::Race.find(params[:id])
    @horses = @race.horses
  end
end
