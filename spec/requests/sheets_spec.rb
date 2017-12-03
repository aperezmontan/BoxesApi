require 'rails_helper'

describe "Sheets", :type => :request do
  let!(:sheet) { create(:sheet) }
  let!(:sheets) { [sheet] }

  describe 'post /sheets' do
    let(:body) { JSON.parse(response.body) }

    subject { post "/sheets", :params => { :sheet => { :home_team => "home", :away_team => "away", :game_id => Game.first.id, :user_id => User.first.id } } }

    context "with valid params" do
      it "creates the sheet" do
        expect{ subject }.to change{ ::Sheet.count }.by(1)
      end

      it "responds 201 status" do
        subject
        expect(response.status).to eq(201)
      end

      it "responds with sheet" do
        subject

        expect(response.content_type).to eq("application/json")
        expect(body["sheet"]["home_team"]).to eq("home")
        expect(body["sheet"]["away_team"]).to eq("away")
      end
    end

    context "with bad params" do
      context "without unpermitted params" do
        it "ignores unpermitted params" do
          post "/sheets", :params => { :sheet => { :home_team => "home", :away_team => "away", :game_id => Game.first.id, :user_id => User.first.id, :foo => "bar" } }

          expect(response.status).to eq(201)
        end
      end

      context "with incomplete params" do
        it "responds with an error" do
          post "/sheets", :params => { :sheet => { :home_team => "home", :user_id => User.first.id } }

          expect(response.status).to eq(422)
        end
      end

      # TODO: test when Devise is setup
      xcontext "without a user" do
        xit "responds with an error" do
          post "/sheets", :params => { :sheet => { :home_team => "home", :away_team => "away", :game_id => Game.first.id } }

          expect(response.status).to eq(422)
          expect(body).to eq("user" => ["must exist"])
        end
      end

      context "without a game" do
        it "responds with an error" do
          post "/sheets", :params => { :sheet => { :home_team => "home", :away_team => "away", :user_id => User.first.id } }

          expect(response.status).to eq(422)
          expect(body).to eq("game" => ["must exist"])
        end
      end
    end
  end

  describe 'delete /sheets/:id' do
    context "with valid sheet" do
      subject { delete "/sheets/#{sheet.id}" }

      it "destroys the sheet" do
        expect{ subject }.to change{ ::Sheet.count }.by(-1)
      end

      it "responds 204 status" do
        subject
        expect(response.status).to eq(204)
      end
    end

    context "with invalid sheet" do
      subject { delete "/sheets/foo" }

      it "responds with an error" do
        subject
        expect(response.status).to eq(422)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe '/sheets' do
    before { get '/sheets' }

    let(:sheets_response) do
      sheets.map do |sheet|
        {
          "id"=>sheet.id,
          "name"=>sheet.name,
          "home_team"=>sheet.home_team,
          "away_team"=>sheet.away_team,
        }
      end
    end

    let(:expected_response) { { "sheets" => sheets_response } }

    it "responds 200 status" do
      expect(response.status).to eq(200)
    end

    it "responds with sheets" do
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
  end

  describe 'get /sheets/:id' do
    before { get "/sheets/#{sheet.id}" }

    let(:sheets_response) do
      {
        "id"=>sheet.id,
        "name"=>sheet.name,
        "home_team"=>sheet.home_team,
        "away_team"=>sheet.away_team,
      }
    end

    let(:expected_response) { { "sheet" => sheets_response } }

    it "responds 200 status" do
      expect(response.status).to eq(200)
    end

    it "responds with sheet" do
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
  end

  describe 'put /sheets/:id' do
    before do
      subject
      sheet.reload
    end

    let(:sheets_response) do
      {
        "id"=>sheet.id,
        "name"=>sheet.name,
        "home_team"=>sheet.home_team,
        "away_team"=>sheet.away_team,
      }
    end

    let(:expected_response) { { "sheet" => sheets_response } }

    context "with valid params" do
      subject { put "/sheets/#{sheet.id}", :params => { :sheet => { :home_team => "NY", :away_team => "NJ" } } }

      it "updates the sheet" do
        expect(sheet.home_team).to eq("NY")
        expect(sheet.away_team).to eq("NJ")
      end

      it "responds 200 status" do
        expect(response.status).to eq(200)
      end

      it "responds with sheet" do
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end

    context "with invalid params" do
      subject { put "/sheets/#{sheet.id}", :params => { :sheet => { :home_team => nil } } }

      it "responds with an error" do
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq("home_team"=>["can't be blank"])
      end
    end
  end
end
