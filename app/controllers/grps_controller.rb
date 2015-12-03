class GrpsController < ApplicationController
  # GET /grps
  # GET /grps.xml
  def index
    @grps = Grp.all

    respond_to do |format|
      format.json  { render :json => @grps }
      format.xml  { render :xml => @grps }
    end
  end

  # GET /grps/1
  # GET /grps/1.xml
  def show
    @grp = Grp.find(params[:id])

    respond_to do |format|
      format.json  { render :json => @grp.to_json(:except =>[:lat, :lon, :created_at, :updated_at, :status, :state, :grp_area_id]) }
      format.xml  { render :xml => @grp }
    end
  end
end
