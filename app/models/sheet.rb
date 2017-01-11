class Sheet < ActiveRecord::Base
  has_many :boxes, :dependent => :destroy

  validates :home_team, :away_team, :presence => true

  before_create :init_boxes
  before_create :generate_code
  before_save :set_team_score_arrays, :if => Proc.new { |sheet| sheet.closed? && sheet.team_score_arrays_blank? }

  def set_team_score_arrays
    self.home_team_score_row = random_score_array
    self.away_team_score_row = random_score_array
    self.save
  end

  def random_score_array
    (0..9).to_a.shuffle
  end

  def all_boxes_full?
    boxes.all? { |box| box.owner_name.present? }
  end

  def team_score_arrays_blank?
    home_team_score_row.blank? || away_team_score_row.blank?
  end

  private

  def generate_code
    self.sheet_code = ("A".."Z").to_a.shuffle.sample(4).join
  end

  def init_boxes
    # Creates 100 boxes with coordinates being a letter between A and J
    ids = ("A".."J").to_a
    id_array = ids.product(ids)
    id_array.each do |x_coord, y_coord|
      self.boxes.build(:home_team_id => x_coord, :away_team_id => y_coord)
    end 
  end
end
