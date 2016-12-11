
Rails.application.routes.draw do
  resources :election_protocols
  resources :candidate_lists
  resources :ballot_boxes
  resources :ballot_papers
  resources :candidates
  resources :elections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #require 'sidekiq/web'
  #mount Sidekiq::Web => '/sidekiq'

  root 'home#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sessions/destroy'
  
  post '/candidate_lists/:id/submit_candidacy', to: 'candidate_lists#submit_candidacy'
  delete '/candidate_lists/:id/destroy_candidacy/:candidate_id', to: 'candidate_lists#destroy_candidacy'

  get 'elections/:id/count_votes', to: 'elections#count_votes'
  post 'elections/:id/count_votes', to: 'elections#count_votes'

end
