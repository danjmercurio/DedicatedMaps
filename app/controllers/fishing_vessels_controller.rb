class FishingVesselsController < ApplicationController
  layout "private" 
  before_filter :ensure_login
  
    # POST /fishing_vessel
  def update
    @vessel = FishingVessel.find(params[:id])

    respond_to do |format|
      if @vessel.update_attributes(params[:fishing_vessel])
        format.js { render :text =>  "Vessel information successfully updated." }
      else
        format.js { render :text =>  "Error: vessel information not updated." }
      end
    end
  end
 
end