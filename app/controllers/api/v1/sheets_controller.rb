module Api
  module V1
    class SheetsController < ApplicationController
      before_action :set_sheet, :only => [:destroy, :show, :update]
      before_action :authenticate_user!, :only => [:create, :update, :destroy]
      before_action :permit_user_update, :only => [:update, :destroy]

      def create
        @sheet = current_user.sheets.build(sheet_params)

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

      def permit_user_update
        raise ArgumentError unless @sheet.belongs_to_user?(current_user)
      end

      def set_sheet
        @sheet = ::Sheet.find(params[:id])
      end

      def sheet_params
        params.require(:sheet).permit(:home_team, :away_team, :box_amount, :password, :name, :closed)
      end
    end
  end
end

