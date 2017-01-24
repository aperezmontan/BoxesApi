module Api
  module V1
    class BoxesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_sheet
      before_action :set_box
      before_action :permit_user_update

      def update
        raise ArgumentError unless params[:sheet_password].present?
        if @box.update(box_params)
          head :no_content
        else
          render json: @box, :status => :unprocessable_entity
        end
      end

      private

      def permit_user_update
        raise ArgumentError unless @box.belongs_to_user?(current_user)
      end

      def box_params
        params.require(:box).permit(:owner_name, :user_id)
      end

      def set_sheet
        @sheet = ::Sheet.find(params[:sheet_id])
      end

      def set_box
        @box = ::Box.find(params[:id])
      end
    end
  end
end
