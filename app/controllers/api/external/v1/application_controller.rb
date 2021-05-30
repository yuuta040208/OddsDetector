# frozen_string_literal: true

class Api::External::V1::ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from StandardError do |e|
    render json: { message: e.message }, status: :internal_server_error
  end

  def not_found(e: nil)
    render json: { message: e&.message || 'resource is not found' }, status: :not_found
  end
end
