# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    home_team 'NYG'
    away_team 'NYJ'
    game_date Time.now
  end
end
