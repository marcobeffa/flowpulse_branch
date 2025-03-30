Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :trees, only: [ :show ]
    end
  end

  resources :external_posts, except: [ :index, :show ]
  resources :profiles do
    resources :trees, only: %i[ show index ]
  end
  resources :businesses, only: %i[ show index ]
  resources :projects, only: %i[ show index ]
  get "pages/home"
  get "about", to: "pages#about"
  resource :session
  resources :passwords, param: :token

  resources :branches do
    member do
      get :updateposition
      get :ordinabile
      get :ul

      get :mappa
    end
  end
  # match "/branches/:id/update_position", to: "branches#updateposition", via: :patch

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
