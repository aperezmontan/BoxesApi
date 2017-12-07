# frozen_string_literal: true

require 'rails_helper'

describe 'Boxes', :type => :request do
  include_context 'shared auth'

  let(:owner) { User.first || create(:user) }
  let(:game) { create(:game) }
  let(:sheet_params) do
    {
      :name => 'new_sheet',
      :user_id => owner.id,
      :game_id => game.id
    }
  end
  let!(:sheet) do
    sheet = ::Sheet.start_new_sheet(sheet_params)
    sheet.save
    sheet
  end
  let!(:box) { sheet.boxes.sample }

  let(:headers) { auth_headers }
  let(:body) { JSON.parse(subject.body) }

  describe 'put /boxes/:id' do
    subject do
      request
      response
    end

    before do
      subject
      box.reload
    end

    let(:expected_response) { { 'box' => boxes_response } }

    context 'with valid params' do
      context 'sets the owner' do
        let(:request) do
          get "/boxes/#{box.id}/set_owner", :headers => headers
        end
        let(:owner_id) { owner.id }
        let(:boxes_response) { { 'id' => box.id, 'owner_id' => owner.id } }

        it_behaves_like 'authorized user endpoint'

        it 'updates the box' do
          expect(box.owner_id).to eq(owner_id)
        end

        it 'responds 200 status' do
          expect(subject.status).to eq(200)
        end

        it 'responds with box' do
          expect(body).to eq(expected_response)
        end
      end

      context 'unsets the owner' do
        let(:request) do
          box.owner_id = owner.id
          box.save
          get "/boxes/#{box.id}/unset_owner", :headers => headers
        end
        let(:owner_id) { nil }
        let(:boxes_response) { { 'id' => box.id, 'owner_id' => nil } }

        it 'updates the box' do
          expect(box.owner_id).to eq(owner_id)
        end

        it 'responds 200 status' do
          expect(subject.status).to eq(200)
        end

        it 'responds with box' do
          expect(body).to eq(expected_response)
        end
      end
    end

    context 'when trying to unset the owner' do
      let(:request) do
        box.owner_id = create(:user).id
        box.save
        get "/boxes/#{box.id}/unset_owner", :headers => headers
      end

      it 'can only be done by the current owner' do
        expect(subject.status).to eq(403)
        expect(body['error']).to eq("can't be updated by this User")
      end

      xit 'or admin' do

      end
    end
  end
end
