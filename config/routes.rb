Rails.application.routes.draw do
  scope module: 'api' do
    scope module: 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :games, :only => [:index]
      resources :sheets, :except => [:new, :edit] do
        resources :boxes, :only => [:update]
      end
    end
  end  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
