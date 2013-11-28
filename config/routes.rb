SoundCampaign::Application.routes.draw do
  concern :undestroyable do
    member do
      put :undestroy
    end
  end
  
  root to: 'subscribers#new'
  resources :subscribers
  
  resources :labels,
    concerns: :undestroyable
  
  resources :releases,
    concerns: :undestroyable do
    resources :feedbacks
    resource  :metrics
    resource  :campaign do
      post :preview
      post :deliver
    end
  end
  
  resources :artists, 
    concerns: :undestroyable
  
  resources :tracks,
    only: %i[create destroy]
  
  resources :covers,
    only: %i[create]
  
  resources :track_events,
    only: %i[create index]
  
  resources :contact_lists,
    concerns: :undestroyable do
    
    resources :contacts,
      concerns: :undestroyable
    
    resources :imports,
      only: %i[index new create show] do
      member do
        get  :prepare
        post :execute
      end
    end
  end
  
  resources :mandrill
  
  resources :mockups, only: %i[index show]
  
  devise_for :users
end
