class AssetsController < ApplicationController
  layout "private" 
  before_filter :ensure_login
  
  # GET /assets
  # GET /assets.xml
  def index
    if @loggedin_user.super?
      # public ships have a client_id = NULL
      @assets = Asset.find(:all, :conditions => ['client_id IS NOT NULL'], :order => :client_id)
     elsif @loggedin_user.admin?
      # Can only list users with the same client
      @assets = Asset.find(:all, :conditions => {:client_id => @loggedin_user.client_id} )
    else 
      # standard users can't view assets list
      error_404
    end  
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /assets/1
  def show
    @asset = Asset.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb     
      format.xml  { render :xml => @asset }
      format.json  { render :json => @asset.constitute.to_json}
    end
  end
  
  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = Asset.new
    @visibilities = Visibility.all
    @asset_types = AssetType.all(:order => :sort)
    if @loggedin_user.super?
      @clients = Client.all
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
    @client = @asset.client
    @custom_field = CustomField.new
    @icons = Icon.find_all_by_asset_type_id(@asset.asset_type_id)       
    @visibilities = Visibility.all
    @device = Device.new
    @device_types = DeviceType.all
    if @asset.asset_type.name == 'fishing_vessel'
      @fishing_trip = FishingTrip.new
      @fishing_trips = FishingTrip.find_all_by_fishing_vessel_id(
        @asset.fishing_vessel.id, :order=>"created_at DESC",
        :include => [:fishermen, :fish, :real_fish, :fishing_gear]
      )
      @fishing_gear = FishingGear.all
      @fish = Fish.all
      @fishermen = @asset.client.fishermen.all(:order => :last_name)
    end
  end

  # POST /assets
  def create
    @asset = Asset.new(params[:asset])
    if !@asset.client_id
      @asset.client_id = @loggedin_user.client_id
    end
    
    respond_to do |format|
      if @asset.save
   
        case @asset.asset_type.name
          when 'ship'
            @ship = Ship.create(:asset_id => @asset.id)
          when 'aircraft'
            @aircraft = Aircraft.create(:asset_id => @asset.id) 
          when 'fishing_vessel'
            @fishing_vessel = FishingVessel.create(:asset_id => @asset.id)
          when 'other'
            @other = Other.create(:asset_id => @asset.id)
        end
        
        flash[:notice] = 'Asset was successfully created.'
        format.html { redirect_to(edit_asset_path(@asset)) }
      else
        flash[:notice] = 'Error: Asset was not created.'
        format.html { redirect_to :back }
      end
    end
  end
  
  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = Asset.find(params[:id])

    # if all checkboxes are unchecked, no params are sent.
    # to get around this we set a hidden param: device_checkboxes.
    # If it's present and the checkbox values
    # are not, then we know to clear all of the tethers.
    if params[:device_checkboxes]
      Tether.delete_all(:asset_id => @asset.id) if params[:asset].nil?
    end
    if params[:sharing_checkboxes]
      SharedAsset.delete_all(:asset_id => @asset.id) if params[:asset].nil?
    end
    
    respond_to do |format|
      if @asset.update_attributes!(params[:asset])
        format.html { 
          flash[:notice] = 'Asset was successfully updated.'
          redirect_to :back
        }
        format.xml  { head :ok }
        format.js {render :text => "Asset information updated."}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
        format.js {render :Text => "Error: Asset information not updated."}
        end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    if @asset.destroy
      flash[:notice] = 'Asset was deleted.'

      respond_to do |format|
        format.html { redirect_to(assets_url) }
        format.xml  { head :ok }
      end
    end
  end
end
