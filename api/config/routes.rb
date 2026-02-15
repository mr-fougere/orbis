Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/register', to: 'auth#register'
      get '/profile', to: 'auth#profile'

      resources :games, only: [:create ]
    end
  end
end
