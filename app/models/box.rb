class Box < ActiveRecord::Base
  belongs_to :sheet
  after_save :save_sheet

  delegate :home_team, :to => :sheet
  delegate :away_team, :to => :sheet

  def save_sheet
    sheet.save
  end
end
