class ClientsController < ApplicationController
  layout "private" 
  before_filter :ensure_login, :ensure_super
  
  # GET /clients
  def index
    @clients = Client.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /clients/new
  def new
    @client = Client.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
    @license = License.new
    @layers = Layer.all(:order => :sort)
    @clients = Client.all(:conditions => ['id <> ?', @client.id])
  end

  # POST /clients
  def create
    @client = Client.new(params[:client])
    
    respond_to do |format|
      if @client.save
        
        #Every client gets a public map user with a map
        priv = Privilege.find_by_name('public')
        uniq = ([Array.new(9){rand(256).chr}.join].pack('m').chomp[1..8] + Time.now.to_f.to_s).gsub('.','_')
        pw = [Array.new(9){rand(256).chr}.join].pack('m').chomp
        user = User.create(
          :client => @client,
          :privilege => priv,
          :username => uniq,
          :first_name => 'Public Map',
          :last_name => 'User',
          :email => "#{uniq}@foobar.com",
          :password => pw,
          :password_confirmation => pw,
          :eula => true)
        Map.create(:user => user)
        
        flash[:notice] = 'Client was successfully created. 
                          Make sure to set up licenses, layers, and an admin user.'
        format.html { redirect_to(:action => 'edit', :id => @client.id) }
      else
        flash[:notice] = 'Error creating client.'
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /clients/1
  def update
    @client = Client.find(params[:id])

    # if all checkboxes are unchecked, no params are sent.
    # to get around this we set hidden params: layer_checkboxes and
    # shared_checkboxes. If they're present and the checkbox values
    # are not, then we know to clear all of the layers/clients.
    if params[:layer_checkboxes]
      @client.remove_all_layers if params[:client][:layer_ids].nil? # layer permissions
    end
    if params[:sharing_checkboxes]
      @client.remove_all_clients if params[:client].nil? # sharing with other clients
    end

   respond_to do |format|
     if @client.update_attributes(params[:client])
        format.html { 
          flash[:notice] = 'Company account successfully updated.'
          redirect_to :action => "edit" 
        }
        format.js { render :text =>  "Client account successfully updated." }
      else
        format.html { render :action => "edit" }
        format.js { render :text =>  "Error. Client account not updated." }
      end
    end
  end

end