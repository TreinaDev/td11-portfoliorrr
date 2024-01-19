Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :job_categories, only: %i[index create]
  resource :profile, only: %i[show], controller: :profile, as: :user_profile
  resource :personal_info, only: %i[edit update], controller: :personal_info, as: :user_personal_info
end
