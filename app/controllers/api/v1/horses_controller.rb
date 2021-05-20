# frozen_string_literal: true

class Api::V1::HorsesController < Api::ApplicationController
  def show
    @horse = Nankan::Horse.find(params[:id])
  end
end
