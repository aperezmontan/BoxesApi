module Api
  module V1
    class SheetsController < ApplicationController
      before_action :set_sheet, :only => [:destroy, :show, :update]

      def create
        @sheet = ::Sheet.new(sheet_params)

        if @sheet.save
          render json: @sheet, :status => :created, :adapter => :json
        else
          render json: @sheet.errors, :status => :unprocessable_entity, :adapter => :json
        end
      end

      def destroy
        if @sheet.destroy
          render json: {}, :status => :no_content, :adapter => :json
        else
          render json: @sheet.errors, :status => :unprocessable_entity, :adapter => :json
        end
      end

      def index
        @sheets = ::Sheet.all
        render json: @sheets, :adapter => :json
      end

      def show
        render json: @sheet, :adapter => :json
      end

      def update
        if @sheet.update_attributes(sheet_params)
          render json: {}, :status => :no_content, :adapter => :json
        else
          render json: @sheet.errors, :status => :unprocessable_entity, :adapter => :json
        end
      end

      private

      def set_sheet
        @sheet = ::Sheet.find(params[:id])
      end

      def sheet_params
        params.require(:sheet).permit(:home_team, :away_team, :box_amount, :password, :name, :closed)
      end
    end
  end
end

