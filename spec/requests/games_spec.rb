# frozen_string_literal: true

require 'rails_helper'

describe 'Games', :type => :request do
  include_context 'shared auth'

  let!(:game) { create(:game) }
  let!(:games) { [game] }

  subject do
    request
    response
  end

  let(:headers) { auth_headers }
  let(:body) { JSON.parse(subject.body) }

  describe 'post /games' do
    let(:game_params) do
      {
        :home_team => 'NYG',
        :away_team => 'NYJ',
        :game_date => Time.now.utc.iso8601
      }
    end

    context 'with valid params' do
      let(:request) do
        post '/games',
             :params => { :game => game_params },
             :headers => headers
      end

      it_behaves_like 'authorized user endpoint'

      it 'creates the game' do
        expect { subject }.to change { ::Game.count }.by(1)
      end

      it 'responds 201 status' do
        expect(subject.status).to eq(201)
      end

      it 'responds with game' do
        expect(subject.content_type).to eq('application/json')
        expect(body['game']['home_team']).to eq('NYG')
        expect(body['game']['away_team']).to eq('NYJ')
      end
    end

    context 'with bad params' do
      context 'with unpermitted params' do
        let(:request) do
          post '/games',
               :params => { :game => game_params.merge!(:foo => 'bar') },
               :headers => headers
        end

        it 'ignores unpermitted params' do
          expect(subject.status).to eq(201)
        end
      end

      context 'with incomplete params' do
        let(:request) do
          post '/games',
               :params => { :game => { :home_team => 'home', :game_time => Time.now.utc.iso8601 } },
               :headers => headers
        end

        it 'responds with an error' do
          expect(subject.status).to eq(422)
        end
      end
    end
  end

  describe 'get /games' do
    let(:request) { get '/games' }

    let(:games_response) do
      games.map do |game|
        {
          'id' => game.id,
          'game_date' => game.game_date.utc.iso8601,
          'home_team' => game.home_team,
          'away_team' => game.away_team
        }
      end
    end

    let(:expected_response) { { 'games' => games_response } }

    it 'responds 200 status' do
      expect(subject.status).to eq(200)
    end

    it 'responds with games' do
      expect(body).to eq(expected_response)
    end
  end

  describe 'get /games/:id' do
    let(:request) { get "/games/#{game.id}" }

    let(:games_response) do
      {
        'id' => game.id,
        'game_date' => game.game_date.utc.iso8601,
        'home_team' => game.home_team,
        'away_team' => game.away_team
      }
    end

    let(:expected_response) { { 'game' => games_response } }

    it 'responds 200 status' do
      expect(subject.status).to eq(200)
    end

    it 'responds with game' do
      expect(body).to eq(expected_response)
    end

    context 'with invalid game' do
      let(:request) { get '/games/foo' }

      it 'response with a 404' do
        expect(subject.status).to eq(404)
        expect(body['error']).to eq("Couldn't find Game with 'id'=foo")
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
        'game_date' => game.game_date.utc.iso8601,
        'home_team' => game.home_team,
        'away_team' => game.away_team
      }
    end

    let(:expected_response) { { 'game' => games_response } }

    context 'with valid params' do
      let(:request) do
        put "/games/#{game.id}",
            :params => { :game => { :home_team => 'LAC', :away_team => 'LAR' } },
            :headers => headers
      end

      it_behaves_like 'authorized user endpoint'

      it 'updates the game' do
        expect(game.home_team).to eq('LAC')
        expect(game.away_team).to eq('LAR')
      end

      it 'responds 200 status' do
        expect(subject.status).to eq(200)
      end

      it 'responds with game' do
        expect(body).to eq(expected_response)
      end
    end

    context 'with invalid params' do
      let(:request) do
        put "/games/#{game.id}",
            :params => { :game => { :home_team => 'foo' } },
            :headers => headers
      end

      it 'responds with a 422' do
        expect(subject.status).to eq(422)
        expect(body['error']).to eq("'foo' is not a valid home_team")
      end
    end
  end
end
