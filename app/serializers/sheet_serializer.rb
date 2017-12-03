# frozen_string_literal: true

class SheetSerializer < ActiveModel::Serializer
  attributes :id, :name, :home_team, :away_team
end
