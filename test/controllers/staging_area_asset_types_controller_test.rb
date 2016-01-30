require 'test_helper'

class StagingAreaAssetTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staging_area_asset_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staging_area_asset_type" do
    assert_difference('StagingAreaAssetType.count') do
      post :create, :staging_area_asset_type => { }
    end

    assert_redirected_to staging_area_asset_type_path(assigns(:staging_area_asset_type))
  end

  test "should show staging_area_asset_type" do
    get :show, :id => staging_area_asset_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => staging_area_asset_types(:one).to_param
    assert_response :success
  end

  test "should update staging_area_asset_type" do
    put :update, :id => staging_area_asset_types(:one).to_param, :staging_area_asset_type => { }
    assert_redirected_to staging_area_asset_type_path(assigns(:staging_area_asset_type))
  end

  test "should destroy staging_area_asset_type" do
    assert_difference('StagingAreaAssetType.count', -1) do
      delete :destroy, :id => staging_area_asset_types(:one).to_param
    end

    assert_redirected_to staging_area_asset_types_path
  end
end
