Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  resources :job_categories, only: %i[index create destroy]
  resources :profiles, only: [] do
    get 'search', on: :collection
  end

  resources :posts, only: %i[new create] do
    resources :comments, only: %i[create]
    post 'pin', on: :member
  end

  resources :users, only: [] do
    resources :posts, shallow: true, only: %i[show edit update]
    resources :profiles, shallow: true, only: %i[show] do
      resources :connections, only: %i[create index] do
        patch 'unfollow', 'follow_again'
      end
      get 'following', controller: 'connections'
    end
  end

  resource :profile, only: %i[edit update show], controller: :profile, as: :user_profile 
  resources :likes, only: %i[create destroy]  
  resources :profile_job_categories, only: %i[new create]
end
