ComuniItaliani::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.


  resources :regions, shallow: true do
    resources :provinces, shallow: true do
      resources :municipalities, shallow: true
    end
  end

  resources :pictures

  match 'provinces' => 'provinces#all', :as => :provinces
  match 'municipalities' => 'municipalities#all', :as => :municipalities

  match 'map' => 'municipalities#map', :as => :map

  match 'regions/search/:word' => 'regions#search', :as => :regions_search  
  match 'provinces/search/:word' => 'provinces#search', :as => :provinces_search  
  match 'municipalities/search/:word' => 'municipalities#search', :as => :municipalities_search
  # match 'search/:word' => 'search#search', :as => :search
  # match 'search/:word/:type' => 'search#search', :as => :search

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
  root :to => 'regions#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
