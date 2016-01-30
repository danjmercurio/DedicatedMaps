require 'test_helper'

class StagingAreaAssetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staging_area_assets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staging_area_asset" do
    assert_difference('StagingAreaAsset.count') do
      post :create, :staging_area_asset => { }
    end

    assert_redirected_to staging_area_asset_path(assigns(:staging_area_asset))
  end

  test "should show staging_area_asset" do
    get :show, :id => staging_area_assets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => staging_area_assets(:one).to_param
    assert_response :success
  end

  test "should update staging_area_asset" do
    put :update, :id => staging_area_assets(:one).to_param, :staging_area_asset => { }
    assert_redirected_to staging_area_asset_path(assigns(:staging_area_asset))
  end

  test "should destroy staging_area_asset" do
    assert_difference('StagingAreaAsset.count', -1) do
      delete :destroy, :id => staging_area_assets(:one).to_param
    end

    assert_redirected_to staging_area_assets_path
  end
end
