class DevicesController < ApplicationController
  layout "private"
  before_filter :ensure_login, :except => [:update_locations]

  def update_locations
    interval = params[:id]
    target = case interval
      when '1' then 'phone'
      when '5' then 'spot'
    end
    DeviceType.find_by_name(target).devices.each do |d|
      #d.send_later(:update_location) if d.assets.any? {|a| a.is_active}
      d.update_location if d.assets.any? {|a| a.is_active}
    end
    render :text => 'OK'
  end

  # GET /devices
  def index
    if @loggedin_user.super?
      @devices = Device.find(:all, :conditions => ['client_id IS NOT NULL'] )
    elsif @loggedin_user.admin?
      # Can only list devices with the same client
      @devices = Device.find(:all, :conditions => {:client_id => @loggedin_user.client_id} )
    else
      # standard users can't view devices list
      error_404
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /devices/new
  # GET /devices/new.xml
  def new
    @device_types = DeviceType.all
    if @loggedin_user.super?
      @clients = Client.all
    end
    @device = Device.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
  end

  # POST /devices
  # POST /devices.xml
  def create

    # @device = Device.find_or_initialize_by_serial_number(params[:device])
    @device = Device.new(params[:device])

    if params[:client_id].nil?
      @client = @loggedin_user.client
    else
      @client = Client.find(params[:client_id])
    end

    @device.client_id = @client.id

    respond_to do |format|
      format.html {
        if @device.save
          flash[:notice] = 'Device was successfully created.'
          redirect_to(:devices)
          else
          flash[:notice] = 'Error creating device.'
          redirect_to(:back)
        end
      }

      format.js {
        if @device.save
          @device = Device.new
          @device_types = DeviceType.all
          @asset = Asset.find(params[:device][:asset_ids])
        end
        render :partial => 'assets/devices',
                :locals  => {:client => @client,
                             :device => @device,
                             :asset => @asset}
      }
    end
  end

  # PUT /devices/1
  # PUT /devices/1.xml
    def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        flash[:notice] = 'Device was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.xml
  def destroy
    @device = Device.find(params[:id])
    if @device.destroy
      flash[:notice] = 'Device was deleted.'

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {render :partial => 'assets/devices',
                        :locals  => {:client => @client,
                                     :device => @device}
                 }
      end
    end
  end
    
  

  def show
    
  end

end
