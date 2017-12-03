# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      def index
        @games = ::Game.all
        render :json => @games
      end
    end
  end
end
