class StagingAreaFeedsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  skip_before_filter :subdomain_redirect, :only => [:create]
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
      #Check for HTTP basic authentication
      if @is_authenticated
        # Check for a valid company id
        if !params.has_key?(:company_id) || params[:company_id].blank? || params[:company_id].to_i.class.name != "Fixnum" || params[:company_id].to_i == 0          
          format.html {
            render :text => 'Error: A company_id parameter is required. (Must be a nonzero integer)', :status => 422
          }
        
        # Check for a present and readable file
        elsif params[:map_locations].class.name.demodulize != "UploadedFile"
          format.html {
            render :text => "Error: No map locations file supplied or file is unreadable. Add a Dedicated Maps Map Locations XML file to the request with the parameter name 'map_locations'", :status => 422
          }


        # Check that the file is non-empty
        elsif params[:map_locations].read.length == 0
          format.html {
            render :text => 'Error: Map locations file present, but empty.', :status => 422
          }
        # Start parsing
        else
          result = StagingArea.parse_uploads(params)
        end

        if result == 'OK'
          title = StagingAreaCompany.find(params[:company_id]).title
          format.html {
            render :text => "Staging area assets for #{title} posted successfully. Data will be available on maps momentarily."
          }
        else
          format.html {
            render :text => "Error: " + result.inspect, :status => 500
          }
        end 
      else
        format.html {
          render :text => "Unauthorized to access.", :status => 401
        }
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