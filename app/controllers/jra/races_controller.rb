# frozen_string_literal: true

class JRA::RacesController < ApplicationController
  def index
    @races = JRA::Race.all.order(hold_at: :desc).order(:number).page(params[:page])
  end

  def show
    @race = JRA::Race.find(params[:id])
    @horses = @race.horses
  end
end
