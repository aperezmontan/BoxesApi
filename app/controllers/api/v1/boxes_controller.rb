# frozen_string_literal: true

module Api
  module V1
    class BoxesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_box

      def set_owner
        @box = ::BoxOwnerAdder.new(@box, @current_user).run

        render :json => @box, :adapter => :json
      end

      def unset_owner
        @box = ::BoxOwnerRemover.new(@box, @current_user).run

        render :json => @box, :adapter => :json
      end

      private

      def set_box
        @box ||= ::Box.find(params[:id])
      end
    end
  end
end
