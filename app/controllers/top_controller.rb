# frozen_string_literal: true

class TopController < ApplicationController
  def index
    @jra_race_count = JRA::Race.all.count
    @nankan_race_count = Nankan::Race.all.count

    latest_jra_race = JRA::Race.where(number: 11).order(:start_at).last
    latest_nankan_race = Nankan::Race.where(number: 11).order(:start_at).last
    @latest_race = latest_jra_race.start_at > latest_nankan_race.start_at ? latest_jra_race : latest_nankan_race
    @react_endpoint = latest_jra_race.start_at > latest_nankan_race.start_at ? 'js/entrypoints/jra/topPage' : 'js/entrypoints/nankan/topPage'
  end
end
