# frozen_string_literal: true

class Game < ApplicationRecord
  TEAMS = {
    'ARI' => 'Arizona Cardinals',
    'ATL' => 'Atlanta Falcons',
    'BAL' => 'Baltimore Ravens',
    'BUF' => 'Buffalo Bills',
    'CAR' => 'Carolina Panthers',
    'CHI' => 'Chicago Bears',
    'CIN' => 'Cincinnati Bengals',
    'CLE' => 'Cleveland Browns',
    'DAL' => 'Dallas Cowboys',
    'DEN' => 'Denver Broncos',
    'DET' => 'Detroit Lions',
    'GB' => 'Green Bay Packers',
    'HOU' => 'Houston Texans',
    'IND' => 'Indianapolis Colts',
    'JAX' => 'Jacksonville Jaguars',
    'LAC' => 'Los Angeles Chargers',
    'LAR' => 'Los Angeles Rams',
    'KC' => 'Kansas City Chiefs',
    'MIA' => 'Miami Dolphins',
    'MIN' => 'Minnesota Vikings',
    'NE' => 'New England Patriots',
    'NO' => 'New Orleans Saints',
    'NYG' => 'New York Giants',
    'NYJ' => 'New York Jets',
    'OAK' => 'Oakland Raiders',
    'PHI' => 'Philadelphia Eagles',
    'PIT' => 'Pittsburgh Steelers',
    'SEA' => 'Seattle Seahawks',
    'SF' => 'San Francisco 49ers',
    'TB' => 'Tampa Bay Buccaneers',
    'TEN' => 'Tennessee Titans',
    'WAS' => 'Washington Redskins'
  }.freeze

  enum :home_team => TEAMS.keys, :_suffix => :home_team
  enum :away_team => TEAMS.keys, :_suffix => :away_team

  ### Associations
  has_many :sheets

  ### Validations
  validates_presence_of :home_team, :away_team, :game_date
  validate :home_team_and_away_team_cannot_be_the_same

  private

  def home_team_and_away_team_cannot_be_the_same
    errors.add(:home_team, 'cannot be the same as away team') if home_team == away_team
  end
end
