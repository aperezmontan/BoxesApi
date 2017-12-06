# frozen_string_literal: true

require 'rails_helper'

describe ::Game do
  subject { described_class.new(:home_team => 'NYG', :away_team => 'NYJ', :game_date => Time.now) }

  it 'creates a new game with valid params' do
    expect(subject).to be_valid
  end

  context 'assocations' do
    subject { described_class.create(:home_team => 'NYG', :away_team => 'NYJ', :game_date => Time.now) }

    it '#sheets' do
      expect(subject.sheets.new).to be_a_new(::Sheet)
    end
  end

  context 'validations' do
    context 'home_team' do
      it 'ensures home_team exists' do
        expect { described_class.create!(:away_team => 'NYJ', :game_date => Time.now) }
          .to raise_error(::ActiveRecord::RecordInvalid, "Validation failed: Home team can't be blank")
      end

      it 'ensures home_team is valid' do
        expect { described_class.create!(:home_team => 'foo', :away_team => 'NYJ', :game_date => Time.now) }
          .to raise_error(::ArgumentError, "'foo' is not a valid home_team")
      end
    end

    context 'away_team' do
      it 'ensures away_team exists' do
        expect { described_class.create!(:home_team => 'NYJ', :game_date => Time.now) }
          .to raise_error(::ActiveRecord::RecordInvalid, "Validation failed: Away team can't be blank")
      end

      it 'ensures away_team is valid' do
        expect { described_class.create!(:away_team => 'foo', :home_team => 'NYJ', :game_date => Time.now) }
          .to raise_error(::ArgumentError, "'foo' is not a valid away_team")
      end
    end

    context 'home_team and away_team' do
      it 'ensures home_team and away_team are not equal' do
        expect { described_class.create!(:home_team => 'NYJ', :away_team => 'NYJ', :game_date => Time.now) }
          .to raise_error(::ActiveRecord::RecordInvalid, 'Validation failed: Home team cannot be the same as away team')
      end
    end
  end
end
