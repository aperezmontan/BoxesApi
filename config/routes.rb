# frozen_string_literal: true

Rails.application.routes.draw do
  scope :module => 'api' do
    scope :module => 'v1' do
      mount_devise_token_auth_for 'User', :at => 'auth'
      resources :games, :except => %i[new edit destroy]
      resources :sheets, :except => %i[new edit] do
        resources :boxes, :only => [:update]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
