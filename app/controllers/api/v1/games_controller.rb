# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      # TODO: REMOVE THIS ONCE YOU HAVE ALL SERVICES
      before_action :set_game, :only => %i[destroy show update]
      # before_action :authenticate_user!, :only => [:create, :update]
      # before_action :permit_user_update, :only => [:update, :destroy]

      def create
        binding.pry
        # TODO: when devise is set up this won't be needed.  It sets current_user
        current_user = User.find(game_params.fetch(:user_id))
        @game = ::GameAdder.new(game_params, current_user).run

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
        # TODO: when devise is set up this won't be needed.  It sets current_user
        binding.pry
        current_user = User.find(@game.user_id)
        @game = ::GameUpdater.new(game_params.merge!(:id => @game.id), current_user).run

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
              .permit(:home_team, :away_team, :box_amount, :password, :name, :closed, :game_id, :user_id)
      end
    end
  end
end
