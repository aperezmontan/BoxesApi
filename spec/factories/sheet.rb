FactoryBot.define do
  factory :sheet do
    home_team "home"
    away_team "away"
    name "new_sheet"
    user
    game
  end
end