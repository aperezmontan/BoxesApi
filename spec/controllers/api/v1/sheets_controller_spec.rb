require 'rails_helper'

describe ::Api::V1::SheetsController do
  let!(:sheet) { ::Sheet.create(:home_team => "home", :away_team => "away") }
  let!(:sheets) { ::Sheet.all }

  describe "#create" do
    subject { post :create, :sheet => { :home_team => "home", :away_team => "away" } }

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
        body = JSON.parse(response.body)

        expect(response.content_type).to eq("application/json")
        expect(body["home_team"]).to eq("home")
        expect(body["away_team"]).to eq("away")
      end
    end

    context "with invalid params" do
      it "responds with an error" do
        post :create, :sheet => { :home_team => "home" }
        body = JSON.parse(response.body)

        expect(response.status).to eq(422)
        expect(response.content_type).to eq("application/json")
        expect(body["away_team"]).to eq(["can't be blank"])
      end
    end
  end

  describe "#destroy" do
    subject { post :destroy, :id => sheet.id }

    it "destroys the sheet" do
      expect{ subject }.to change{ ::Sheet.count }.by(-1)
    end

    it "responds 204 status" do
      subject
      expect(response.status).to eq(204)
    end

    context "with invalid params" do
      it "responds with an error" do
        allow(::Sheet).to receive(:find).and_return(sheet)
        allow(sheet).to receive(:destroy).and_return(false)
        post :destroy, :id => sheet.id
        body = JSON.parse(response.body)

        expect(response.status).to eq(422)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "#index" do
    before { get :index }

    it "sets the sheet" do
      expect(assigns(:sheets)).to eq(sheets)
    end

    it "responds 200 status" do
      expect(response.status).to eq(200)
    end

    it "responds with sheets" do
      expect(response.body).to eq(sheets.to_json)
    end
  end

  describe "#show" do
    before { get :show, :id => sheet.id }

    it "sets the sheet" do
      expect(assigns(:sheet)).to eq(sheet)
    end

    it "responds 200 status" do
      expect(response.status).to eq(200)
    end

    it "responds with sheet" do
      expect(response.body).to eq(sheet.to_json)
    end
  end

  describe "#update" do
    subject { post :update, :id => sheet.id, :sheet => { :home_team => "NY", :away_team => "NJ" } }

    context "with valid params" do
      it "updates the sheet" do
        subject
        sheet.reload

        expect(sheet.home_team).to eq("NY")
        expect(sheet.away_team).to eq("NJ")
      end

      it "responds 204 status" do
        subject
        expect(response.status).to eq(204)
      end
    end

    context "with invalid params" do
      it "responds with an error" do
        post :update, :id => sheet.id, :sheet => { :home_team => nil }
        body = JSON.parse(response.body)

        expect(response.status).to eq(422)
        expect(response.content_type).to eq("application/json")
      end
    end
  end
end
