Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'home#index'

  resources :advertisements, only: %i[index show new create update]

  resources :searches, only: %i[index]
  resources :invitations, only: %i[index show] do
    patch 'decline', on: :member
  end

  resources :invitation_requests, only: %i[index]

  resources :projects, only: %i[index]
  post '/projects', to: 'projects#create_invitation_request', as: 'invitation_request'

  resources :job_categories, only: %i[index create destroy]
  resources :notifications, only: %i[index update]

  resources :posts, only: %i[new create] do
    resources :comments, shallow: true, only: %i[create] do
      resources :replies, only: %i[create]
    end
    post 'pin', on: :member
  end

  resources :subscriptions, only: %i[index update]

  resources :reports, only: %i[index new create show] do
    member do
      post 'reject'
      post 'remove_content'
      post 'remove_profile'
    end
  end

  resources :posts, only: %i[] do
    patch 'publish', on: :member
    resources :likes, only: %i[create destroy], module: :posts
  end

  resources :comments, only: %i[] do
    resources :likes, only: %i[create destroy], module: :comments
  end

  resources :replies, only: %i[] do
    resources :likes, only: %i[create destroy], module: :replies
  end

  resources :users, only: [] do
    resources :posts, shallow: true, only: %i[show edit update]
    resources :profiles, shallow: true, only: %i[edit show update] do
      resources :settings, only: %i[index]
      patch :remove_photo, on: :member
      resources :connections, only: %i[create index] do
        patch 'unfollow', 'follow_again'
      end
      get 'following', controller: 'connections'
    end
  end

  delete 'delete_account', controller: :settings
  patch 'deactivate_profile', 'work_unavailable', 'open_to_work', 'change_privacy', controller: :settings

  resources :job_categories, only: %i[index create]
  resource :profile, only: %i[edit update], controller: :profile, as: :user_profile do
    resources :professional_infos, shallow: true, only: %i[new create edit update]
    resources :education_infos, shallow: true, only: %i[new create edit update]
  end

  resources :profile_job_categories, only: %i[new create edit destroy update]

  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index]
      resources :job_categories, only: %i[index show]
      resources :profiles, only: %i[show index]
      resources :invitations, only: %i[create update]
      resources :invitation_request, only: %i[update]

      get 'projects/request_invitation', controller: :projects
    end
  end
end
