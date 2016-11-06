class Sheet < ActiveRecord::Base
  has_many :boxes, :dependent => :destroy

  validates :home_team, :away_team, :presence => true

  after_initialize :init_boxes

  private

  def init_boxes
    # Creates 100 boxes with coordinates being a letter between A and J
    ids = ("A".."J").to_a
    id_array = ids.product(ids)
    id_array.each do |coord|
      self.boxes.build(:home_team_id => coord[0], :away_team_id => coord[1])
    end if new_record?
  end
end
