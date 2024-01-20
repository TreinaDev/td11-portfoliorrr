Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  resources :users, only: [] do
    resources :posts, shallow: true, only: %i[index show new create edit update]
    resources :profiles, shallow: true, only: %i[show]
  end

  resources :job_categories, only: %i[index create]
end
