
Rails.application.routes.draw do
  resources :candidate_lists
  resources :ballot_boxes
  resources :ballot_papers
  resources :candidates
  resources :elections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #require 'sidekiq/web'
  #mount Sidekiq::Web => '/sidekiq'

  root 'elections#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sessions/destroy'
  
end
