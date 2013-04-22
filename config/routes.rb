SoundCampaign::Application.routes.draw do
  root to: 'subscribers#new'
  resources :subscribers
  
  resources :labels
  resources :releases
  resources :artists
  resources :tracks, only: %i[create destroy show]
  resources :contact_lists do
    resources :contacts
  end
  
  resources :mockups, only: %i[index show]
  
  devise_for :users
end
