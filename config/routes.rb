SoundCampaign::Application.routes.draw do
  root to: 'subscribers#new'
  resources :subscribers
  
  resources :labels
  resources :releases
  resources :artists
  
  resources :mockups, only: %i[index show]
  
  devise_for :users
end
