Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ('/')
  root 'articles#index'

  namespace :dashboard do
    root to: 'base#index'
    resource :profile, only: [:edit, :update, :show], controller: 'profiles'
    resource :site_settings, only: [:edit, :update, :show], controller: 'site_settings'
    resources :articles, only: [:new, :create, :edit, :update, :destroy, :index, :show]

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end

  resources :articles, only: [:index, :show] do
    collection do
      get :feed, defaults: { format: 'rss' }
    end
  end

  post '/images', to: 'images#create'

end
