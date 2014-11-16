SoundCampaign::Application.routes.draw do
  concern :undestroyable do
    member do
      put :undestroy
    end
  end
  
  root to: 'subscribers#new'
  resources :subscribers
  
  resources :organizations do
    member do
      put :switch
    end
  end
  
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
    except: %i[edit update] do
    member do
      get :stream
      get :download
    end
  end
  
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
  
  if Rails.env.development?
    require 'mail_preview'
    mount MailPreview => 'mail_view'
    resources :mockups, only: %i[index show]
  end
  
  require_administrator = -> request {
    request.env['warden'].authenticated?
    request.env['warden'].authenticate!
    request.env['warden'].user.try(:has_role?, 'admin')
  }
  
  constraints require_administrator do
    mount DelayedJobWeb => 'jobs'
  end
  
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
end
