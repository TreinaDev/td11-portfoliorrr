Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :job_categories, only: %i[index create]
end
