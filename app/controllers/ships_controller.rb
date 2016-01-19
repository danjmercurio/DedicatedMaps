class ShipsController < ApplicationController
  before_filter :ensure_login, :only => [:update]

  def index
    # Called by my_ships, shared_ships, and public_ships asset map layers
    # returns asset lists
         
    @asset_type_id = AssetType.find_by_name('ship').id

    case params[:distill]
      when 'my'
        @min_visibility = Visibility.find_by_name("Private")
        @assets = Asset.find_all_by_client_id_and_asset_type_id(
          @loggedin_user.client.id,
          @asset_type_id,
          :conditions => ["visibility_id >= ?", @min_visibility.id],
          :include => [:current_location, {:ship => :icon}]
        )
      when 'shared'
        @min_visibility = Visibility.find_by_name("Shared")
        @assets = Asset.find_all_by_asset_type_id(
          @asset_type_id,
          :joins => :shared_assets,
          :conditions => ["visibility_id >= ? AND shared_assets.client_id = ?", @min_visibility.id, @loggedin_user.client.id],
          :include => [:current_location, {:ship => :icon}]
        )
      when 'public'
        # don't show public ships that will show up in the shared layer
        @min_visibility = Visibility.find_by_name("Shared")
        @shared = Asset.joins("INNER JOIN `shared_assets` ON `assets`.`id` = `shared_assets`.`asset_id`").
        where("visibility_id >= ? AND asset_type_id = ?", @min_visibility.id, @asset_type_id)
        # .find_all_by_asset_type_id(@asset_type_id)
 
        @min_visibility = Visibility.find_by_name("Public")
       
        # Primary Ships
        if @shared.length == 0
          @assets = Asset.includes([:current_location, {:ship => :icon}]).
          where("visibility_id = ? AND asset_type_id = ?", @min_visibility.id, @asset_type_id)
        else
          @assets = Asset.includes([:current_location, {:ship => :icon}]).
          where("visibility_id = ? AND asset_type_id = ? AND id NOT IN (?)", @min_visibility.id, @asset_type_id, @shared.pluck(:id))
        end

        # @assets = Asset.find_all_by_asset_type_id(
        #   @asset_type_id,
        #   :conditions => ["visibility_id = ? AND (client_id <> ? OR client_id IS NULL) AND id NOT IN (?)",
        #     @min_visibility.id, @loggedin_user.client.id, @shared],
        #   :include => [{:current_location => :device}, {:ship => :icon}]
        # )
        #find_all_by_asset_type_id(@asset_type_id)


        # @assets = @assets | Asset.find_all_by_asset_type_id(
        #   @fishing_type_id,
        #   :conditions => ["visibility_id = ? AND (client_id <> ? OR client_id IS NULL) AND id NOT IN (?)",
        #     @min_visibility.id, @loggedin_user.client.id, @shared_fishing],
        #   :include => [{:current_location => :device}, {:fishing_vessel => :icon}]
        # ) 
        #find_all_by_asset_type_id(@fishing_type_id)

    end
    
    @assets = @assets.reject {|s| s.ship.nil?}

    @results = @assets.collect {|s|
      {
        :id => s.id,
        :name => (s.common_name ? s.common_name : "MMSI: " + s.current_location.device.serial_number),
        :suffix =>(s.ship.icon ? s.ship.icon.suffix : "Uns"),
        :cog => s.ship.cog,
        :lat => s.current_location.lat,
        :lon => s.current_location.lon,
        :dim_bow => s.ship.dim_bow,
        :dim_stern => s.ship.dim_stern,
        :dim_port => s.ship.dim_port,
        :dim_starboard => s.ship.dim_starboard,
        :no_info => (s.ship.icon ? false : true)
      }
    }
    
    @fishing_type_id = AssetType.find_by_name('fishing_vessel').id
    #add fishing vessels    
    case params[:distill]
      when 'my'
        @min_visibility = Visibility.find_by_name("Private")
        @fishing_assets = Asset.find_all_by_client_id_and_asset_type_id(
          @loggedin_user.client.id,
          @fishing_type_id,
          :conditions => ["visibility_id >= ?", @min_visibility.id],
          :include => [:current_location, {:fishing_vessel => :icon}]
        )

      when 'shared'
        @min_visibility = Visibility.find_by_name("Shared")
        @fishing_assets = Asset.find_all_by_asset_type_id(
          @fishing_type_id,
          :joins => :shared_assets,
          :conditions => ["visibility_id >= ? AND shared_assets.client_id = ?", @min_visibility.id, @loggedin_user.client.id],
          :include => [:current_location, {:fishing_vessel => :icon}]
        )
      when 'public'
        # don't show public ships that will show up in the shared layer
        @min_visibility = Visibility.find_by_name("Shared")
        # @shared_fishing = Asset.joins("INNER JOIN `shared_assets` ON `assets`.`id` = `shared_assets`.`asset_id`").find_all_by_client_id_and_asset_type_id(
        #   @fishing_type_id,
        #   :conditions => ,
        #   :include => [:current_location, {:fishing_vessel => :icon}]
        # )

        @shared_fishing = Asset.joins("INNER JOIN `shared_assets` ON `assets`.`id` = `shared_assets`.`asset_id`").
        where("visibility_id >= ? AND asset_type_id = ?", @min_visibility.id, @fishing_type_id)#find_all_by_client_id_and_asset_type_id(@loggedin_user.client.id, @fishing_type_id)
     
        @min_visibility = Visibility.find_by_name("Public")
        
        # @fishing_assets = Asset.find_all_by_asset_type_id(
        #   @fishing_type_id,
        #   :select => "`assets`.`id`",
        #   :conditions => ["visibility_id = ? AND (client_id <> ? OR client_id IS NULL) AND id NOT IN (?)",
        #     @min_visibility.id, @loggedin_user.client.id, @shared_fishing],
        #  @ :include => [{:current_location => :device}, {:fishing_vessel => :icon}]
        # )

        # Fishing Vessels
        if @shared_fishing.length == 0
          @fishing_assets = Asset.includes([:current_location, {:ship => :icon}]).
          where("visibility_id = ? AND asset_type_id = ?", @min_visibility.id, @fishing_type_id)
        else          
          @fishing_assets = Asset.includes([:current_location, {:ship => :icon}]).
          where("visibility_id = ? AND asset_type_id = ? AND id NOT IN (?)", @min_visibility.id, @fishing_type_id, @shared_fishing.pluck(:id))
        end
    end

    @results = @results | @fishing_assets.collect {|s|
      {
        :id => s.id,
        :name => (s.common_name ? s.common_name : "MMSI: " + s.current_location.device.serial_number),
        :suffix => s.fishing_vessel.icon.suffix + ["_G", "_N", "_P"][rand(3)],
        :cog => s.fishing_vessel.cog,
        :lat => s.current_location.lat,
        :lon => s.current_location.lon,
        :dim_bow => (s.fishing_vessel.length ? s.fishing_vessel.length/2 : 0),
        :dim_stern => (s.fishing_vessel.length ? s.fishing_vessel.length/2 : 0),
        :dim_port => (s.fishing_vessel.width ? s.fishing_vessel.width/2 : 0),
        :dim_starboard => (s.fishing_vessel.width ? s.fishing_vessel.width/2 : 0),
        :no_info => false
      }
    }

    respond_to do |format|
      format.json  { render :json => @results.to_json() }
    end
  end  
   
  # PUT /ships/1
  # PUT /ships/1.xml
  def update
    @asset = Asset.find(params[:id])
    @ship = Ship.find_by_asset_id(@asset.id)
    @icons = Icon.find_all_by_asset_type_id(@asset.asset_type_id)
    
    respond_to do |format|
      if @ship.update_attributes(params[:ship])
        #flash[:notice] = 'Ship was successfully updated.'
      else
        #flash[:notice] = 'Ship was successfully updated.'
      end
      format.js  {render :partial => 'assets/ship',
                   :locals  => {:asset => @asset, 
                                :icons => @icons
                               } }
    end
  end

end