Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ('/')
  root 'articles#index'

  get 'articles/rss', to: 'articles#feed', defaults: { format: 'rss' }, as: 'articles_feed'
  resources :articles
  get 'drafts', to: 'articles#drafts'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resource :site_settings, only: [:edit, :update]
  get 'site_settings', to: redirect('/site_settings/edit')

  post '/images', to: 'images#create'

end
