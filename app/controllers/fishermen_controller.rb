class FishermenController < ApplicationController
  layout "private" 
  before_filter :ensure_login
    
  # GET /fishermen
  def index
    if @loggedin_user.super?
      @fishermen = Fisherman.find(:all, :conditions => {:active => true}, :order => "client_id, last_name")
      @clients = Client.all
    elsif @loggedin_user.admin?
      # Can only list fishermen with the same client
      @fishermen = Fisherman.find_all_by_client_id(@loggedin_user.client_id, :order => :last_name)
    else 
      # standard users can't view fishing_trips list
      error_404
    end
    
    @fisherman = Fisherman.new
    respond_to do |format|
      format.html
    end
  end

  # PUT /fishermen/1
  def update
    @fisherman = Fisherman.find(params[:id])
    respond_to do |format|
      if @fisherman.update_attributes(params[:fisherman])
        format.js  {render :partial => 'form', :locals  => {:fisherman => @fisherman}}
      else
        format.js  {render :txt => "Error saving crew member data."}
      end        
    end
  end
  
  # POST /fishermen
  def create
    @fisherman = Fisherman.new(params[:fisherman])
 
    respond_to do |format|
      if @fisherman.save
        #flash[:notice] = 'Field data was successfully saved.'
        @client = @fisherman.client
        @fisherman = Fisherman.new
      else
        flash[:notice] = 'Error saving field data.'
      end
      format.html  {redirect_to :fishermen}
    end
  end
  
  def destroy
    @fisherman = Fisherman.find_by_id(params[:id])
    @fisherman.active = false
    
    respond_to do |format|
      if @fisherman.save
        # flash[:notice] = 'Crew member deleted.'
        @client = @fisherman.client
        @fisherman = Fisherman.new
        format.js  {render :text => ""}
      else
        format.js  {render :text => "Error deleting crew member."}
      end
    end
  end
  
end