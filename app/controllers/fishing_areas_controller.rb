class FishingAreasController < ApplicationController
  # GET /map_areas
  # GET /map_areas.xml
  def index
    @fishing_areas = FishingArea.all

    respond_to do |format|
      format.xml  { render :xml => @fishing_areas }
      format.json  { render :json => @fishing_areas.to_json(:include => {:fishing_area_points => {:only => [:lat, :lon]}} ) }
    end
  end

  # GET /map_areas/1
  # GET /map_areas/1.xml
  def show
    @fishing_area = FishingArea.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @fishing_area }
      format.json  { render :json => @fishing_area.to_json(:include => {:fishing_area_points => {:only => [:lat, :lon]}} ) }
    end
  end

end
