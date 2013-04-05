SoundCampaign::Application.routes.draw do
  root to: 'labels#index'
  resources :labels
  
  devise_for :users
end
