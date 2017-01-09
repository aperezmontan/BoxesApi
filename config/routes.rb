Rails.application.routes.draw do
  scope module: 'api' do
    scope module: 'v1' do
      resources :sheets, :except => [:new, :edit] do
        resources :boxes, :only => [:update]
      end
    end
  end
end
