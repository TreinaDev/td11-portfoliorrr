Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :job_categories, only: %i[index create]
  resource :profile, only: %i[edit update show], controller: :profile, as: :user_profile
end
