Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :profiles, only: [] do
    get 'search', on: :collection
  end

  resources :job_categories, only: %i[index create]
end
