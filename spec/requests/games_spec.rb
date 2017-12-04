# frozen_string_literal: true

require 'rails_helper'

describe 'Games', :type => :request do
  let!(:game) { create(:game) }
  let!(:games) { [game] }

  describe 'post /games' do
    let(:body) { JSON.parse(response.body) }
    let(:game_params) do
      {
        :name => 'new_new_game',
        :home_team => 'home',
        :away_team => 'away',
        :game_id => Game.first.id,
        :user_id => User.first.id
      }
    end

    subject { post '/games', :params => { :game => game_params } }

    context 'with valid params' do
      it 'creates the game' do
        expect { subject }.to change { ::Game.count }.by(1)
      end

      it 'responds 201 status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'responds with game' do
        subject

        expect(body['game']['home_team']).to eq('home')
        expect(body['game']['away_team']).to eq('away')
      end
    end

    context 'with bad params' do
      context 'without unpermitted params' do
        it 'ignores unpermitted params' do
          post '/games', :params => { :game => game_params.merge!(:foo => 'bar') }

          expect(response.status).to eq(201)
        end
      end

      context 'with incomplete params' do
        it 'responds with an error' do
          post '/games', :params => { :game => { :home_team => 'home', :user_id => User.first.id } }

          expect(response.status).to eq(422)
        end
      end

      let(:bad_game_params) { { :home_team => 'home', :away_team => 'away' } }

      # TODO: test when Devise is setup
      xcontext 'without a user' do
        xit 'responds with an error' do
          post '/games', :params => { :game => bad_game_params.merge!(:game_id => Game.first.id) }

          expect(response.status).to eq(422)
          expect(body).to eq('user' => ['must exist'])
        end
      end

      context 'without a game' do
        it 'responds with an error' do
          post '/games', :params => { :game => bad_game_params.merge!(:user_id => User.first.id) }

          expect(response.status).to eq(422)
          expect(body).to eq('game' => ['must exist'])
        end
      end
    end
  end

  describe '/games' do
    before { get '/games' }

    let(:games_response) do
      games.map do |game|
        {
          'id' => game.id,
          'name' => game.name,
          'home_team' => game.home_team,
          'away_team' => game.away_team
        }
      end
    end

    let(:expected_response) { { 'games' => games_response } }

    it 'responds 200 status' do
      expect(response.status).to eq(200)
    end

    it 'responds with games' do
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
  end

  describe 'get /games/:id' do
    subject { get "/games/#{game.id}" }
    before { subject }

    let(:games_response) do
      {
        'id' => game.id,
        'name' => game.name,
        'home_team' => game.home_team,
        'away_team' => game.away_team
      }
    end

    let(:expected_response) { { 'game' => games_response } }

    it 'responds 200 status' do
      expect(response.status).to eq(200)
    end

    it 'responds with game' do
      expect(JSON.parse(response.body)).to eq(expected_response)
    end

    context 'with invalid game' do
      subject { get '/games/foo' }

      it 'response with a 404' do
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['error']).to eq("Couldn't find Game with 'id'=foo")
      end
    end
  end

  describe 'put /games/:id' do
    before do
      subject
      game.reload
    end

    let(:games_response) do
      {
        'id' => game.id,
        'name' => game.name,
        'home_team' => game.home_team,
        'away_team' => game.away_team
      }
    end

    let(:expected_response) { { 'game' => games_response } }

    context 'with valid params' do
      subject { put "/games/#{game.id}", :params => { :game => { :home_team => 'NY', :away_team => 'NJ' } } }

      it 'updates the game' do
        expect(game.home_team).to eq('NY')
        expect(game.away_team).to eq('NJ')
      end

      it 'responds 200 status' do
        expect(response.status).to eq(200)
      end

      it 'responds with game' do
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end

    context 'with invalid params' do
      subject { put "/games/#{game.id}", :params => { :game => { :home_team => nil } } }

      it 'responds with a 422' do
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['error']).to eq("Validation failed: Home team can't be blank")
      end
    end

    context 'with invalid game' do
      subject { put '/games/foo', :params => { :game => { :home_team => 'NY', :away_team => 'NJ' } } }

      it 'response with a 404' do
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['error']).to eq("Couldn't find Game with 'id'=foo")
      end
    end
  end
end
