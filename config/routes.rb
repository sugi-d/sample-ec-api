Rails.application.routes.draw do
  resources :users, only: [:create]
  post 'users/signin' => 'user_token#create'
  resources :items
  resources :transactions, only: [:create]
end
