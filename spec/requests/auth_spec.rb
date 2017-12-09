# frozen_string_literal: true

require 'rails_helper'

describe 'Auth', :type => :request do
  include_context 'shared auth'
  include_context 'new sheet'

  subject do
    request
    response
  end

  let(:body) { JSON.parse(subject.body) }
  let(:headers) { subject.header }
  let(:params) do
    {
      :email => user.email,
      :password => 'password'
    }
  end
  let(:request) { post '/auth/sign_in', :params => params }

  context 'sign_in' do
    context 'with valid credentials' do
      it 'returns success' do
        expect(subject.status).to eq(200)
      end

      it 'returns an access token' do
        expect(headers.keys).to include('access-token')
      end

      it 'you can use that access token to make requests' do
        access_headers = headers.slice('Content-Type', 'access-token', 'token-type', 'client', 'expiry', 'uid')
        get "/boxes/#{box.id}/set_owner", :headers => access_headers
        expect(response.status).to eq(200)
      end
    end

    context 'with bad credentials' do
      let(:request) { post '/auth/sign_in', :params => bad_params }

      context 'wrong email' do
        let(:bad_params) { params.merge!(:email => 'notme@me.com') }

        it 'returns an error' do
          expect(subject.status).to eq(401)
          expect(body).to eq('errors' => ['Invalid login credentials. Please try again.'])
        end

        it 'does not return an access token' do
          expect(headers.keys).to_not include('access-token')
        end
      end

      context 'wrong password' do
        let(:bad_params) { params.merge!(:password => 'foo') }

        it 'returns an error' do
          expect(subject.status).to eq(401)
          expect(body).to eq('errors' => ['Invalid login credentials. Please try again.'])
        end

        it 'does not return an access token' do
          expect(headers.keys).to_not include('access-token')
        end
      end
    end
  end
end
