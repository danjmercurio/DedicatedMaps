class FishingTripsController < ApplicationController
  layout "private" 
  before_filter :ensure_login
  
  # GET /fishing_trips
  def index
    if @loggedin_user.super?
      @fishing_trips = FishingTrip.find(:all, :order => :date_certified)
     elsif @loggedin_user.admin?
      # Can only list fishing_trips with the same client
      @fishing_trips =FishingTrip.find(:all,
          :conditions => { :fishing_vessel => { :assets => { :client_id => @loggedin_user.client_id }}},
          :joins => [:fishing_vessel => :asset])
    else 
      # standard users can't view fishing_trips list
      error_404
    end  
 
    respond_to do |format|
      format.html
    end
  end
  
  # POST /fishing_trips
  def create
    @vessel = FishingVessel.find(params[:fishing_vessel][:id])
    @fishing_trip = @vessel.fishing_trips.build(params[:fishing_trip])
  
    respond_to do |format|
      if @fishing_trip.save
        @fishing_trip = FishingTrip.new
        @fishing_trips = @vessel.fishing_trips(:order=>"created_at DESC")
        @asset = @vessel.asset
        @fish = Fish.all
        @fishing_gear = FishingGear.all
        @fishermen = @vessel.asset.client.fishermen.all(:order => :last_name)
        
        format.js  {render :partial => 'assets/fishing_trip',
                         :locals  => {
                            :asset => @asset,
                            :fishing_trips => @fishing_trips,
                            :fish => @fish,
                            :fishing_gear => @fishing_gear,
                            :fishermen => @fishermen
                         }
                   }
        format.html {
          redirect_to :back
          flash[:notice] = 'Saved trip successfully.'
        } 
      else
        format.js {render :text => 'Error saving trip data.'}
        format.html {
          redirect_to :back
          flash[:notice] = 'Error saving trip data.'
        }
      end
    end
  end

  
end