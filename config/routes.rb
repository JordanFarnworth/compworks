Rails.application.routes.draw do

  root 'dashboard#index'

  scope '/', defaults: { format: :html }, constraints: { format: :html } do
    resources :users
    resources :companies

    get 'login' => 'login#index'
    post 'login' => 'login#verify'
    delete 'login' => 'login#logout'
  end

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      resources :users, except: [:new, :edit]
      resources :companies, except: [:new, :edit] do
        get 'service_logs' => 'companies#service_logs'
        post 'service_logs' => 'service_logs#create'
        get 'inventory_items' => 'companies#inventory_items'
        post 'inventory_items' => 'inventory_items#create'
      end
    end
  end
end
