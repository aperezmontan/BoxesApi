class Box < ActiveRecord::Base
  belongs_to :sheet

  delegate :home_team, :to => :sheet
  delegate :away_team, :to => :sheet
end
