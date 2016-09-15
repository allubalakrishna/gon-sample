Rails.application.routes.draw do
  resources :authors
  root 'posts#index'
  resources :apidocs, only: [:index]
  resources :posts 
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end