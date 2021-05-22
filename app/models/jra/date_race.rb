# frozen_string_literal: true

class JRA::DateRace
  attr_reader :date, :places, :races

  def initialize(date, places, races)
    @date = date
    @places = places
    @races = races.group_by(&:description)
  end

  def self.all
    initialize_by_races(JRA::Race.all.order(hold_at: :desc).order(:number))
  end


  private

  def self.initialize_by_races(races)
    races.group_by(&:hold_at).map do |date, races|
      new(date, races.pluck(:description).uniq, races)
    end
  end
end
