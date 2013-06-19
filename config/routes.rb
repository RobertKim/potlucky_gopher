# require 'sidekiq/web'
PotluckyGopher::Application.routes.draw do

  match 'auth/:provider/callback', to: 'session#oauth_create'
  match 'auth/failure', to: redirect('/')

  root to: 'pages#index'
  resources :users, :only => [:show, :create, :new, :edit] 
  get '/your_profile', to: 'users#your_profile', as: 'your_profile'
  resources :session, :only => [:destroy, :create]
  post '/login' => 'session#create', :as => 'login'
  match 'signout', to: 'session#destroy', as: 'signout'

  resources :events
  get '/:url' => 'events#invitation', :as => 'invitation'

  resources :items
  
  resources :assigned_items, :except => [:index]
  match 'edit_RSVP/:url' => 'assigned_items#edit'
  match 'remove', to: 'assigned_items#destroy', as: 'remove'
  resources :guest, :only => [:show, :edit, :new, :create]

mount Sidekiq::Web, at: "/sidekiq"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
