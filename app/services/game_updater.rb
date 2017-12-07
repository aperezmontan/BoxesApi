# frozen_string_literal: true

class GameUpdater
  include Service

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def run
    update_game
  end

  private

  def game
    @game ||= ::Game.find(params.fetch('id'))
  end

  def update_game
    game.update_attributes!(params)
    game
  end
end
