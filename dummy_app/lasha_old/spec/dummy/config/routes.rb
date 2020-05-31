Rails.application.routes.draw do
  resources :trees
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "trees#index"
end
