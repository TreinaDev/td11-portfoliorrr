Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  resources :job_categories, only: %i[index create destroy]
  resources :profiles, only: [] do
    get 'search', on: :collection
  end

  resources :posts, only: %i[new create]

  resources :users, only: [] do
    resources :posts, shallow: true, only: %i[index show edit update]
    resources :profiles, shallow: true, only: %i[show]
  end

  resources :job_categories, only: %i[index create]
  resource :profile, only: %i[edit update show], controller: :profile, as: :user_profile do
    resources :professional_infos, shallow: true, only: %i[new create show edit update]
    resources :education_infos, shallow: true, only: %i[new create]
  end
end
