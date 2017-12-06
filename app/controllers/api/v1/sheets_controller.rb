# frozen_string_literal: true

module Api
  module V1
    class SheetsController < ApplicationController
      # TODO: REMOVE THIS ONCE YOU HAVE ALL SERVICES
      before_action :set_sheet, :only => %i[destroy show update]
      before_action :authenticate_user!, :only => %i[create update destroy]
      # before_action :permit_user_update, :only => [:update, :destroy]

      def create
        @sheet = ::SheetAdder.new(sheet_params, @current_user).run

        if @sheet.save
          render :json => @sheet, :status => :created, :adapter => :json
        else
          render :json => @sheet.errors, :status => :unprocessable_entity, :adapter => :json
        end
      end

      def destroy
        @sheet = ::SheetDestroyer.new(@sheet, @current_user).run

        render :json => {}, :status => :no_content, :adapter => :json
      end

      def index
        @sheets = ::Sheet.all
        render :json => @sheets, :adapter => :json
      end

      def show
        render :json => @sheet, :adapter => :json
      end

      def update
        @sheet = ::SheetUpdater.new(sheet_params.merge!(:id => @sheet.id), @current_user).run

        render :json => @sheet, :adapter => :json
      end

      private

      def permit_user_update
        raise ArgumentError unless @sheet.belongs_to_user?(@current_user)
      end

      def set_sheet
        @sheet ||= ::Sheet.find(params[:id])
      end

      def sheet_params
        params.require(:sheet)
              .permit(:home_team, :away_team, :box_amount, :password, :name, :closed, :game_id, :user_id)
      end
    end
  end
end
