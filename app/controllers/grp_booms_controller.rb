class GrpBoomsController < ApplicationController
  # GET /grp_booms
  # GET /grp_booms.xml
  def index
    @grp_booms = GrpBoom.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grp_booms }
      format.json  { render :json => @grp_booms }
    end
  end

  # GET /grp_booms/1
  # GET /grp_booms/1.xml
  def show
    @grp_boom = GrpBoom.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grp_boom }
    end
  end

end