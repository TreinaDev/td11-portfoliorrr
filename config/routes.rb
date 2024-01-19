Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  resources :users, only: [] do
    resources :posts, shallow: true, only: %i[index show new create]
  end
end
