# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      # TODO: REMOVE THIS ONCE YOU HAVE ALL SERVICES
      before_action :set_game, :only => %i[show update]
      before_action :authenticate_user!, :only => %i[create update]
      # before_action :permit_user_update, :only => [:update, :destroy]

      def create
        @game = ::GameAdder.new(game_params).run

        if @game.save
          render :json => @game, :status => :created, :adapter => :json
        else
          render :json => @game.errors, :status => :unprocessable_entity, :adapter => :json
        end
      end

      def index
        @games = ::Game.all
        render :json => @games, :adapter => :json
      end

      def show
        render :json => @game, :adapter => :json
      end

      def update
        @game = ::GameUpdater.new(game_params.merge!(:id => @game.id)).run

        render :json => @game, :adapter => :json
      end

      private

      def permit_user_update
        raise ArgumentError unless @game.belongs_to_user?(current_user)
      end

      def set_game
        @game = ::Game.find(params[:id])
      end

      def game_params
        params.require(:game)
              .permit(:home_team, :away_team, :league, :game_date)
      end
    end
  end
end
