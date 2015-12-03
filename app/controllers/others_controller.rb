class OthersController < ApplicationController
  before_filter :ensure_login, :only => [:update]

  def index
    # Called by my_others, shared_others, and public_others asset map layers
    # returns asset lists
         
    @asset_type_id = AssetType.find_by_name('other').id

    case params[:distill]
      when 'my'
        @min_visibility = Visibility.find_by_name("Private")
        @assets = Asset.find_all_by_client_id_and_asset_type_id(
          @loggedin_user.client.id,
          @asset_type_id,
          :conditions => ["visibility_id >= ?", @min_visibility.id],
          :include => [:current_location, {:other => :icon}]
        )
      when 'shared'
        @min_visibility = Visibility.find_by_name("Shared")
        @assets = Asset.find_all_by_asset_type_id(
          @asset_type_id,
          :joins => :shared_assets,
          :conditions => ["visibility_id >= ? AND shared_assets.client_id = ?", @min_visibility.id, @loggedin_user.client.id],
          :include => [:current_location, {:other => :icon}]
        )
      when 'public'
        # don't show public othersothers that will show up in the shared layer
        @min_visibility = Visibility.find_by_name("Shared")
        @shared = Asset.find_all_by_asset_type_id(
          @asset_type_id,
          :select => "assets.id",
          :joins => :shared_assets,
          :conditions => ["visibility_id >= ? AND shared_assets.client_id = ?", @min_visibility.id, @loggedin_user.client.id]
        )

        @shared = "0" if @shared.length() == 0 
        
        @min_visibility = Visibility.find_by_name("Public")
        @assets = Asset.find_all_by_asset_type_id(
          @asset_type_id,
          :conditions => ["visibility_id = ? AND (client_id <> ? OR client_id IS NULL) AND id NOT IN (?)",
            @min_visibility.id, @loggedin_user.client.id, @shared],
          :include => [{:current_location => :device}, {:other => :icon}]
        )
        @assets = @assets | Asset.find_all_by_asset_type_id(
          @fishing_type_id,
          :conditions => ["visibility_id = ? AND (client_id <> ? OR client_id IS NULL) AND id NOT IN (?)",
            @min_visibility.id, @loggedin_user.client.id, @shared_fishing],
          :include => [{:current_location => :device}, {:fishing_vessel => :icon}]
        ) 

    end
    
    @assets = @assets.reject {|s| s.current_location.nil?}

    @results = @assets.collect {|s|
      {
        :id => s.id,
        :name => (s.common_name ? s.common_name : [s.current_location.device.device_type.title, s.current_location.device.serial_number].join(', ')),
        :lat => s.current_location.lat,
        :lon => s.current_location.lon,
        :no_info => false
      }
    }

    respond_to do |format|
      format.json  { render :json => @results.to_json() }
    end
  end  
   
  # PUT /others/1
  # PUT /others/1.xml
  def update
    @asset = Asset.find(params[:id])
    @other = Other.find_by_asset_id(@asset.id)
    @icons = Icon.find_all_by_asset_type_id(@asset.asset_type_id)
    
    respond_to do |format|
      if @other.update_attributes(params[:other])
        #flash[:notice] = 'Other was successfully updated.'
      else
        #flash[:notice] = 'Other was successfully updated.'
      end
      format.js  {render :partial => 'assets/other',
                   :locals  => {:asset => @asset, 
                                :icons => @icons
                               } }
    end
  end

end