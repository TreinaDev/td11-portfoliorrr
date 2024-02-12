Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'home#index'

  resources :searches, only: %i[index]
  resources :invitations, only: %i[index show] do
    patch 'decline', on: :member
  end

  resources :projects, only: %i[index]
  post '/projects', to: 'projects#create_invitation_request', as: 'invitation_request'

  resources :job_categories, only: %i[index create destroy]
  resources :notifications, only: %i[index]

  resources :posts, only: %i[new create] do
    resources :comments, only: %i[create]
    post 'pin', on: :member
  end

  resources :reports, only: %i[index new create show] do
    post 'reject', on: :member
    post 'remove_content', on: :member
  end

  resources :users, only: [] do
    resources :posts, shallow: true, only: %i[show edit update]
    resources :profiles, shallow: true, only: %i[edit show update] do
      resources 'settings', only: %i[index]
      patch :remove_photo, on: :member
      resources :connections, only: %i[create index] do
        patch 'unfollow', 'follow_again'
      end
      get 'following', controller: 'connections'
    end
  end

  delete 'delete_account', controller: :settings
  patch 'deactivate_profile', controller: :settings
  patch 'work_unavailable', controller: :profiles
  patch 'open_to_work', controller: :profiles
  patch 'change_privacy', controller: :profiles

  resources :likes, only: %i[create destroy]
  resources :job_categories, only: %i[index create]
  resource :profile, only: %i[edit update], controller: :profile, as: :user_profile do
    resources :professional_infos, shallow: true, only: %i[new create edit update]
    resources :education_infos, shallow: true, only: %i[new create edit update]
  end

  resources :profile_job_categories, only: %i[new create]

  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index]
      resources :job_categories, only: %i[index show]
      resources :profiles, only: %i[show index]
      resources :invitations, only: %i[create update]
      
      get 'projects/request_invitation', controller: :projects
    end
  end
end
