Rails.application.routes.draw do

  resources :edges

  resources :tags

  resources :comments

  get 'index' => 'homepage/index'

  root 'homepage#index'

  get 'about' => 'about#index', as: :about


  resources :page_contents

  get '/new_index' => 'admin#index', as: :admin
  # get 'users/:name/admin' => 'admin#index', as: :admin


  controller :sessions do

    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'sessions/create'

  get 'sessions/destroy'


  #posts
  resources :posts 

  get 'reference_posts' => 'posts#ref_posts'

  get 'reference_posts/new' => 'posts#new_ref_post'

  # users
  resources :users, param: :name

  get 'users/:name/profile' => 'users#show'

  get 'developers/:name/profile' => 'users#show'

  patch 'users/:name/record_visitors' => 'users#record_visitors_for_user'


  resources :developers, controller: 'users', param: :name, except: [:show]


  get 'developers/:name/:page_name' => 'page_contents#show_by_name'

  get 'developers/:name' => 'page_contents#show_index_by_name'




  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
