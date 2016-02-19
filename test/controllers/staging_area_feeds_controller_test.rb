require File.dirname(__FILE__) + '/../test_helper'

class StagingAreaFeedsControllerTest < ActionController::TestCase

  test "should require authorization" do  
    post :create
    assert_response 401  
  end
  
  test "should authenticate and upload staging_area files" do

   @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('staging_areas', 'tE5bllwas01Gcwi')
 
   post :create, 
     :company_id      => 1,
     :map_asset_types => fixture_file_upload('../files/crc/Map_Asset_Types.xml', 'text/xml'),
     :map_assets      => fixture_file_upload('../files/crc/Map_Assets.xml', 'text/xml'),
     :map_locations   => fixture_file_upload('../files/crc/Map_Locations.xml', 'text/xml')

   assert_equal "Staging area assets for Clean Rivers Cooperative posted successfully.", @response.body

  end
  
end
