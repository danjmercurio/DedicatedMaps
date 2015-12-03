class StagingAreaFeedsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :authenticate

  #POST /staging_area_feeds
  # This is where we receive the three XML files POSTed by the Access apps
  # for updating equipment caches. There is no model for this controller.
  #
  # Use functional test or curl
  #
  # Test files in test/files/crc/
  #
  # curl -u staging_areas:tE5bllwas01Gcwi ddmaps.heroku.com/staging_area_feeds -F "company_id=1" -F "map_asset_types=@map_asset_types.xml" -F "map_locations=@map_locations.xml" -F "map_assets=@map_assets.xml"
  #
  # curl -u staging_areas:tE5bllwas01Gcwi http://localhost:3000/staging_area_feeds -F "company_id=1" -F "map_asset_types=@map_asset_types.xml" -F "map_locations=@map_locations.xml" -F "map_assets=@map_assets.xml"     
  #
  #
  # curl -u staging_areas:tE5bllwas01Gcwi http://localhost:3000/staging_area_feeds -F "company_id=1" -F "map_locations=@test/files/poi/tbl_POI_MileMarkers.xml"     
  #
  def create
      
    respond_to do |format|
      if @is_authenticated
        
        if !params[:company_id]
          result = "Parameter not set: company_id"
        else
          result = StagingArea.parse_uploads(params)  
        end

        if result == "ok"
          title = StagingAreaCompany.find(params[:company_id]).title
          format.html { render :text => "Staging area assets for #{title} posted sucessfully. Data will be available on maps momentarily."}
        else
          format.html { render :text => "Error: " + result.inspect}
        end 
      else
        format.html { render :text => "Unauthorized to access." }
      end
    end

  end
    
  protected

  def authenticate
    @is_authenticated = authenticate_or_request_with_http_basic do |username, password|
      username == "staging_areas" && password == "tE5bllwas01Gcwi"
    end
  end
end