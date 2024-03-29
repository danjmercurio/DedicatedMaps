class PublicMapsController < ApplicationController
  layout "private"
  before_filter :ensure_super

  #~ # AJAX POST /users/activate
  def activate
    user = User.find(params[:id])

    if user.update_attribute(:active, !user.active)
      if user.active
        message = 'Map enabled successfully.'
      else
        message = 'Map disabled successfully.'
      end
      respond_to do |format|
        format.html do
          flash[:notice] = message
          redirect_to :back
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'Error: Unable to change map status. If this persists, please file a bug report.'
        end
      end
    end
  end

  # GET /public_maps
  def index
    public_privilege = Privilege.find_by_name('public')
    @public_maps = User.where('privilege_id = :privilege', {privilege: public_privilege.id})
  end

  # GET /public_map/new
  def new
    @clients = Client.all
    @public_map = User.new
  end

  # GET /public_map/1/edit
  def edit
    @public_map = User.find(params[:id])
    @clients = Client.all
    @layers = @public_map.client.layers.all.order('created_at DESC')
  end

  # POST /public_map
  def create
    @public_map = User.new(params[:user])
    pword = @public_map.temp_password
    @public_map.password = pword
    @public_map.first_name = 'Public'
    @public_map.last_name = 'User'
    @public_map.email = "#{pword}@dedicatedmaps.com"
    @public_map.eula = true
    @public_map.privilege = Privilege.find_by_name('public')
    begin
      @public_map.save!
      @map = Map.new(:user_id => @public_map.id)
      @map.save!
      flash[:notice] = "Map successfully created."
      redirect_to(:action => 'edit', :id => @public_map.id)
    rescue Exception => e
      flash[:error] = e.message
      @clients = Client.all
      render :action => "new"
    end
  end

  # PUT /public_map/1
  def update
    @public_map = User.find(params[:id])

    # If all checkboxes are unchecked, no params are sent.
    # To get around this we set a hidden param: layer_checkboxes.
    # If it is present and the checkbox values
    # are not, then we know to clear all of the layers.
    if params[:layer_checkboxes] && params[:user][:layer_ids].nil? 
      @public_map.remove_all_layers
    end

    # validate username is unique (Rails validation not working)
    if @public_map.username != params[:user][:username]
      if User.find_by_username(params[:user][:username])
        @clients = Client.all
        @layers = @public_map.client.layers.all(:order => :sort)
        flash[:notice] = 'Domain name is already in use.'
        render 'edit'
        return
      end
    end
    
    @public_map.attributes = params[:user]
    if @public_map.save(:validate => false)
      flash[:notice] = "Map successfully updated."
      redirect_to public_maps_url
    end
  end

  # DELETE /layer/1
  # DELETE /layer/1.xml
  def delete
    @public_map = User.find(params[:id])
    @public_map.destroy

    respond_to do |format|
      format.html { redirect_to(public_maps_url) }
      format.xml  { head :ok }
    end
  end
end