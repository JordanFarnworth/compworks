Rails.application.routes.draw do

  root 'dashboard#index'

  scope '/', defaults: { format: :html }, constraints: { format: :html } do
    resources :users
    resources :companies
    resources :purchase_orders
    resources :service_logs

    get 'login' => 'login#index'
    post 'login' => 'login#verify'
    delete 'login' => 'login#logout'
    get 'admin_dashboard' => 'dashboard#admin_dashboard'
  end

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      get 'undelete' => 'companies#deleted'
      resources :users, except: [:new, :edit]
      resources :purchase_orders, except: [:new, :edit]
      resources :inventory_items, only: [:update, :destroy]
      resources :service_logs, only: [:update, :destroy, :create, :show]
      resources :companies, except: [:new, :edit] do
        put 'undelete' => 'companies#undelete'
        get 'service_logs' => 'companies#service_logs'
        post 'service_logs' => 'service_logs#create'
        get 'inventory_items' => 'companies#inventory_items'
        post 'inventory_items' => 'inventory_items#create'
      end
      get 'item_search' => 'items#item_search'
      get 'vendor_search' => 'vendors#vendor_search'
      post 'mark_po_as_received' => 'purchase_orders#make_po_received'
      post 'mark_po_as_unreceived' => 'purchase_orders#make_po_unreceived'
    end
  end
end
