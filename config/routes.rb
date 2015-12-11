#require 'subdomain'
Ddmap::Application.routes.draw do
  match 'job_viewer' => 'job_viewer#index', :as => :job_viewer
  resources :fishing_areas
  resources :staging_areas
  resources :custom_fields
  match 'staging_areas_company/:id.:format' => 'staging_areas#index', :as => :staging_areas
  match 'marker/:name/:id.:format' => 'markers#show', :as => :markers
  match 'search/:controller/:name/:id.:format' => 'controller#search', :as => :search, :name => :name
  match 'wrrl_company_search/:id.:format' => 'wrrls#company_search', :as => :wrrl_company_search
  match 'wrrl_equipment_type_search/:id.:format' => 'wrrls#equipment_type_search', :as => :wrrls_search
  resources :staging_area_companies
  resources :staging_area_assets
  resources :public_maps
  resources :grp_plans
  resources :grp_areas
  resources :grps
  resources :grp_booms
  resources :grp_boom_types
  resources :devices
  match 'update_locations/:id' => 'devices#update_locations', :as => :update_devices
  resources :layers
  resources :stored_files
  resources :kmls
  resources :points
  resources :fishing_areas
  resources :area_categories
  resources :sessions do

    member do
  get :recovery
  end

  end

  resources :users do
    collection do
      post :recover
      get :reset
    end
  end

  resources :licenses
  resources :ships
  resources :fishing_vessels
  resources :fishing_trips
  resources :fishermen
  resources :privileges
  resources :faria_feeds
  resources :staging_area_feeds
  resources :clients
  resources :assets
  match 'my_ships.:format' => 'ships#index', :as => :my_ships, :distill => 'my'
  match 'shared_ships.:format' => 'ships#index', :as => :shared_ships, :distill => 'shared'
  match 'public_ships.:format' => 'ships#index', :as => :public_ships, :distill => 'public'
  match 'my_ships/:id.:format' => 'assets#show', :as => :my_ships
  match 'shared_ships/:id.:format' => 'assets#show', :as => :shared_ships
  match 'public_ships/:id.:format' => 'assets#show', :as => :public_ships
  match 'my_items.:format' => 'others#index', :as => :my_items, :distill => 'my'
  match 'shared_items.:format' => 'others#index', :as => :shared_items, :distill => 'shared'
  match 'public_items.:format' => 'others#index', :as => :public_items, :distill => 'public'
  match 'my_items/:id.:format' => 'assets#show', :as => :my_items
  match 'shared_items/:id.:format' => 'assets#show', :as => :shared_items
  match 'public_items/:id.:format' => 'assets#show', :as => :public_items
  resources :maps

 
  match '/:controller(/:action(/:id))'


  #match '/' => 'maps#show'
  match '/' => 'public#index'
  match ':page' => 'public#show', :as => :public, :page => /about|contact|products|services|contact|success|ie8/
  match '/' => 'private#index'
  match ':page' => 'private#show', :as => :private, :page => /map|help|admin/

end
