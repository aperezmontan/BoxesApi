# frozen_string_literal: true

shared_examples 'authorized user endpoint' do
  context 'when authorized user endpoint' do
    include_context 'shared auth'

    context 'when valid auth headers are provided' do
      let(:headers) { auth_headers }
      its(:status) { should be_in [200, 201, 204] }
    end

    context 'when invalid auth headers are provided' do
      context 'when access token is invalid' do
        let(:headers) { auth_headers.merge('access-token' => 'foo') }
        its(:status) { should eq 401 }
      end

      context 'when client is invalid' do
        let(:headers) { auth_headers.merge('client' => 'foo') }
        its(:status) { should eq 401 }
      end

      context 'when email is invalid' do
        let(:headers) { auth_headers.merge('uid' => 'foo@me.com') }
        its(:status) { should eq 401 }
      end
    end
  end
end
