# frozen_string_literal: true

class Api::V1::JRA::RacesController < Api::ApplicationController
  def index
    @races = JRA::Race.where(hold_at: Date.today)
  end

  def show
    @race = JRA::Race.find(params[:id])
  end

  def horses
    @race_cards = JRA::Race.find(params[:id]).race_cards.preload(:horse)
  end

  def odds_win
    @data = JRA::Win.eager_load(race_card: :horse).where(jra_race_cards: { jra_race_id: params[:id] }).order(crawled_at: :desc).order(:horse_number).group_by(&:crawled_at).map do |crawled_at, wins|
      hash = { crawled_at: crawled_at }
      hash[:horses] = wins.map do |win|
        { number: win.race_card.horse_number, name: win.race_card.horse_name, odds: win.odds }
      end
      hash
    end
  end

  def odds_place
    @data = JRA::Place.eager_load(race_card: :horse).where(jra_race_cards: { jra_race_id: params[:id] }).order(crawled_at: :desc).order(:horse_number).group_by(&:crawled_at).map do |crawled_at, places|
      hash = { crawled_at: crawled_at }
      hash[:horses] = places.map do |place|
        { number: place.race_card.horse_number, name: place.race_card.horse_name, odds: place.odds }
      end
      hash
    end
  end

  def odds_quinella
    horse_number = params[:horse_number].to_i
    relation = JRA::Quinella.eager_load(race_card: :horse, second_race_card: :horse)
    @data = relation.where(jra_race_cards: { jra_race_id: params[:id] })
              .merge(relation.where(jra_race_cards: { horse_number: horse_number }).or(relation.where(second_race_cards_jra_quinellas: { horse_number: horse_number })))
              .order(crawled_at: :desc)
              .group_by(&:crawled_at)
              .map do |crawled_at, quinellas|
      hash = { crawled_at: crawled_at }

      hash[:horses] = quinellas.map do |quinella|
        race_card = quinella.race_card.horse_number == horse_number ? quinella.second_race_card : quinella.race_card
        { number: race_card.horse_number, name: race_card.horse_name, odds: quinella.odds }
      end.uniq { |quinella| quinella[:number] }.sort_by { |quinella| quinella[:number] }
      hash
    end
  end

  def odds_wide
    horse_number = params[:horse_number].to_i
    relation = JRA::Wide.eager_load(race_card: :horse, second_race_card: :horse)
    @data = relation.where(jra_race_cards: { jra_race_id: params[:id] })
              .merge(relation.where(jra_race_cards: { horse_number: horse_number }).or(relation.where(second_race_cards_jra_wides: { horse_number: horse_number })))
              .order(crawled_at: :desc)
              .group_by(&:crawled_at)
              .map do |crawled_at, wides|
      hash = { crawled_at: crawled_at }

      hash[:horses] = wides.map do |wide|
        race_card = wide.race_card.horse_number == horse_number ? wide.second_race_card : wide.race_card
        { number: race_card.horse_number, name: race_card.horse_name, odds: wide.odds }
      end.uniq { |wide| wide[:number] }.sort_by { |wide| wide[:number] }
      hash
    end
  end
end
