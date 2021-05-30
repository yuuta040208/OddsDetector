# frozen_string_literal: true

class Api::V1::JRA::HorsesController < Api::ApplicationController
  def show
    @horse = JRA::Horse.find(params[:id])
  end
end
