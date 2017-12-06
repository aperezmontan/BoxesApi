# frozen_string_literal: true

class Box < ApplicationRecord
  belongs_to :sheet
  belongs_to :owner, :class_name => 'User', optional: true
  has_one :user, :through => :sheet

  delegate :home_team, :to => :sheet
  delegate :away_team, :to => :sheet
end
