FactoryBot.define do
  factory :sheet do
    home_team "home"
    away_team "away"
    user
    game
  end
end