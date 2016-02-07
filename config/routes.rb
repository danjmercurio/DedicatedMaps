#require 'subdomain'
Ddmap::Application.routes.draw do
  get 'job_viewer' => 'job_viewer#index', :as => :job_viewer
  resources :fishing_areas
  resources :staging_areas
  resources :custom_fields
  get 'staging_areas_company/:id.:format' => 'staging_areas#index' # :as => :staging_areas
  get 'marker/:name/:id.:format' => 'markers#show', :as => :markers
  get 'search/:controller/:name/:id.:format' => 'controller#search', :as => :search, :name => :name
  get 'wrrl_company_search/:id.:format' => 'wrrls#company_search', :as => :wrrl_company_search
  get 'wrrl_equipment_type_search/:id.:format' => 'wrrls#equipment_type_search', :as => :wrrls_search
  resources :staging_area_companies
  resources :staging_area_assets
  resources :public_maps
  resources :grp_plans
  resources :grp_areas
  resources :grps
  resources :grp_booms
  resources :grp_boom_types
  resources :devices
  post 'update_locations/:id' => 'devices#update_locations', :as => :update_devices
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
  #resources :public_ships
  get 'my_ships.:format' => 'ships#index', :distill => 'my' #, :as => :my_ships, 
  get 'shared_ships.:format' => 'ships#index', :distill => 'shared' #, :as => :shared_ships, 
  get 'public_ships.:format' => 'ships#index', :distill => 'public' #, :as => :public_ships, 
  get 'my_ships/:id.:format' => 'assets#show' #, :as => :my_ships
  get 'shared_ships/:id.:format' => 'assets#show' #, :as => :shared_ships
  get 'public_ships/:id.:format' => 'assets#show' #, :as => :public_ships
  #get 'my_items.:format' => 'others#index', :as => :my_items, :distill => 'my'
  # get 'shared_items.:format' => 'others#index', :as => :shared_items, :distill => 'shared'
  # get 'public_items.:format' => 'others#index', :as => :public_items, :distill => 'public'
  # #get 'my_items/:id.:format' => 'assets#show', :as => :my_items
  # get 'shared_items/:id.:format' => 'assets#show', :as => :shared_items
  # get 'public_items/:id.:format' => 'assets#show', :as => :public_items
  resources :maps
 
  get '/:controller(/:action(/:id))'


  post '/license/activate' => 'licenses#activate'

  #match '/' => 'maps#show'
  get '/' => 'public#index'
  get ':page' => 'public#show', :as => :public, :page => /about|contact|products|services|contact|success|ie8/
  get '/' => 'private#index'
  get ':page' => 'private#show', :as => :private, :page => /map|help|admin/

end
