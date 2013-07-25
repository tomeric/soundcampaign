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
    resource  :campaign
  end
  
  resources :artists, 
    concerns: :undestroyable
  
  resources :tracks,
    only: %i[create destroy show]
  
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
  
  resources :mockups, only: %i[index show]
  
  devise_for :users
end
