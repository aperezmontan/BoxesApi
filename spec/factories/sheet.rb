# frozen_string_literal: true

FactoryBot.define do
  factory :sheet do
    name 'new_sheet'
    user
    game
  end
end
