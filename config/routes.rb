SoundCampaign::Application.routes.draw do
  root to: 'subscribers#new'
  resources :subscribers
  
  resources :labels
  
  devise_for :users
end
