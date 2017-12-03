class Sheet < ApplicationRecord
  has_many :boxes, :dependent => :destroy
  belongs_to :user
  belongs_to :game

  validates :home_team, :away_team, :presence => true

  def self.start_new_sheet(sheet_params)
    instance = new(sheet_params.merge!(:sheet_code => self.generate_code))
    self.init_boxes(instance)
    return instance
  end

  def belongs_to_user?(user)
    user_id == user.id
  end

  def set_team_score_arrays
    self.home_team_score_row = random_score_array
    self.away_team_score_row = random_score_array
    self.save
  end

  def all_boxes_full?
    boxes.all? { |box| box.owner_name.present? }
  end

  def team_score_arrays_blank?
    home_team_score_row.blank? || away_team_score_row.blank?
  end

  private

  def self.generate_code
    ("A".."Z").to_a.shuffle.sample(4).join
  end

  def self.init_boxes(instance)
    # Creates 100 boxes with coordinates being a letter between A and J
    ids = ("A".."J").to_a
    id_array = ids.product(ids)
    id_array.each do |x_coord, y_coord|
      instance.boxes.build(:home_team_id => x_coord, :away_team_id => y_coord)
    end
  end

  def random_score_array
    (0..9).to_a.shuffle
  end
end
