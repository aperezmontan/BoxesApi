class Box < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user
  after_save :save_sheet

  delegate :home_team, :to => :sheet
  delegate :away_team, :to => :sheet

  def save_sheet
    sheet.save
  end

  def belongs_to_user?(user)
    user.id == user_id
  end
end
