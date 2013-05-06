SoundCampaign::Application.routes.draw do
  root to: 'subscribers#new'
  resources :subscribers
  
  resources :labels
  resources :releases
  resources :artists
  resources :tracks, only: %i[create destroy show]
  resources :contact_lists do
    resources :contacts
    resources :imports, only: %i[index new create show] do
      member do
        get  :prepare
        post :execute
      end
    end
  end
  
  resources :mockups, only: %i[index show]
  
  devise_for :users
end
