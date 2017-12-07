# frozen_string_literal: true

class GameSerializer < ActiveModel::Serializer
  attributes :id, :home_team, :away_team
  attribute :game_date do
    object.game_date.utc.iso8601
  end
end
