Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  resources :users, shallow: true, only: [] do
    resources :posts, only: %i[index show]
  end
end
