# frozen_string_literal: true

require 'rails_helper'

describe 'Sheets', :type => :request do
  include_context 'shared auth'

  let!(:sheet) { create(:sheet) }
  let!(:sheets) { [sheet] }

  subject do
    request
    response
  end

  let(:headers) { auth_headers }
  let(:body) { JSON.parse(subject.body) }

  describe 'post /sheets' do
    let(:sheet_params) do
      {
        :name => 'new_new_sheet',
        :home_team => 'home',
        :away_team => 'away',
        :game_id => Game.first.id,
        :user_id => User.first.id
      }
    end

    context 'with valid params' do
      let(:request) do
        post '/sheets',
             :params => { :sheet => sheet_params },
             :headers => headers
      end

      it_behaves_like 'authorized user endpoint'

      it 'creates the sheet' do
        expect { subject }.to change { ::Sheet.count }.by(1)
      end

      it 'responds 201 status' do
        expect(subject.status).to eq(201)
      end

      it 'responds with sheet' do
        expect(subject.content_type).to eq('application/json')
        expect(body['sheet']['home_team']).to eq('home')
        expect(body['sheet']['away_team']).to eq('away')
      end
    end

    context 'with bad params' do
      context 'without unpermitted params' do
        let(:request) do
          post '/sheets',
               :params => { :sheet => sheet_params.merge!(:foo => 'bar') },
               :headers => headers
        end

        it 'ignores unpermitted params' do
          expect(subject.status).to eq(201)
        end
      end

      context 'with incomplete params' do
        let(:request) do
          post '/sheets',
               :params => { :sheet => { :home_team => 'home' } },
               :headers => headers
        end

        it 'responds with an error' do
          expect(subject.status).to eq(422)
        end
      end

      let(:bad_sheet_params) { { :home_team => 'home', :away_team => 'away' } }

      context 'without a game' do
        let(:request) do
          post '/sheets',
               :params => { :sheet => bad_sheet_params },
               :headers => headers
        end

        it 'responds with an error' do
          expect(subject.status).to eq(422)
          expect(body).to eq('game' => ['must exist'])
        end
      end
    end
  end

  describe 'delete /sheets/:id' do
    context 'with valid sheet' do
      let(:request) { delete "/sheets/#{sheet.id}", :headers => headers }

      it_behaves_like 'authorized user endpoint'

      it 'destroys the sheet' do
        expect { subject }.to change { ::Sheet.count }.by(-1)
      end

      it 'responds 204 status' do
        expect(subject.status).to eq(204)
      end
    end

    context 'with invalid sheet' do
      let(:request) { delete '/sheets/foo', :headers => headers }

      it 'responds with an error' do
        expect(subject.status).to eq(422)
        expect(subject.content_type).to eq('application/json')
      end
    end
  end

  describe '/sheets' do
    let(:request) { get '/sheets' }

    let(:sheets_response) do
      sheets.map do |sheet|
        {
          'id' => sheet.id,
          'name' => sheet.name,
          'home_team' => sheet.home_team,
          'away_team' => sheet.away_team
        }
      end
    end

    let(:expected_response) { { 'sheets' => sheets_response } }

    it 'responds 200 status' do
      expect(subject.status).to eq(200)
    end

    it 'responds with sheets' do
      expect(body).to eq(expected_response)
    end
  end

  describe 'get /sheets/:id' do
    let(:request) { get "/sheets/#{sheet.id}" }

    let(:sheets_response) do
      {
        'id' => sheet.id,
        'name' => sheet.name,
        'home_team' => sheet.home_team,
        'away_team' => sheet.away_team
      }
    end

    let(:expected_response) { { 'sheet' => sheets_response } }

    it 'responds 200 status' do
      expect(subject.status).to eq(200)
    end

    it 'responds with sheet' do
      expect(body).to eq(expected_response)
    end
  end

  describe 'put /sheets/:id' do
    before do
      subject
      sheet.reload
    end

    let(:sheets_response) do
      {
        'id' => sheet.id,
        'name' => sheet.name,
        'home_team' => sheet.home_team,
        'away_team' => sheet.away_team
      }
    end

    let(:expected_response) { { 'sheet' => sheets_response } }

    context 'with valid params' do
      let(:request) do
        put "/sheets/#{sheet.id}",
            :params => { :sheet => { :home_team => 'NY', :away_team => 'NJ' } },
            :headers => headers
      end

      it_behaves_like 'authorized user endpoint'

      it 'updates the sheet' do
        expect(sheet.home_team).to eq('NY')
        expect(sheet.away_team).to eq('NJ')
      end

      it 'responds 200 status' do
        expect(response.status).to eq(200)
      end

      it 'responds with sheet' do
        expect(body).to eq(expected_response)
      end
    end

    context 'with invalid params' do
      let(:request) do
        put "/sheets/#{sheet.id}",
            :params => { :sheet => { :home_team => nil } },
            :headers => headers
      end

      it 'responds with an error' do
        expect(response.status).to eq(422)
        expect(body).to eq('home_team' => ["can't be blank"])
      end
    end
  end
end
