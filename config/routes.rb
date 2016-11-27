
Rails.application.routes.draw do
  resources :ballot_papers
  resources :candidates
  resources :elections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'elections#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sessions/destroy'
  
end
