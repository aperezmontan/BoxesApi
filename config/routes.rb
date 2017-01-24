Rails.application.routes.draw do
  scope module: 'api' do
    scope module: 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :sheets, :except => [:new, :edit] do
        resources :boxes, :only => [:update]
      end
    end
  end
end
