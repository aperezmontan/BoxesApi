# frozen_string_literal: true

module Api
  module V1
    class BoxesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_box

      def update
        @box = ::BoxUpdater.new(box_params.merge!(:id => @box.id), @current_user).run

        render :json => @box, :adapter => :json
      end

      private

      def box_params
        params.require(:box).permit(:owner_name, :user_id)
      end

      def set_box
        @box ||= ::Box.find(params[:id])
      end
    end
  end
end
