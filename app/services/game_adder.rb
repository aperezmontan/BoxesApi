# frozen_string_literal: true

class GameAdder
  include Service

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def run
    add_game
  end

  private

  def add_game
    @game ||= ::Game.new(params)
  end
end
