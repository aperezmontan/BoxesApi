shared_context 'shared auth' do
  let(:user) { User.first || create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
end