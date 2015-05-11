Rails.application.routes.draw do

  root 'dashboard#index'

  resources :users

  get 'login' => 'login#index'
  post 'login' => 'login#verify'
  delete 'login' => 'login#logout'
end
