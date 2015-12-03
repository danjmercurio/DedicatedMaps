require 'test_helper'

class StagingAreasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staging_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staging_area" do
    assert_difference('StagingArea.count') do
      post :create, :staging_area => { }
    end

    assert_redirected_to staging_area_path(assigns(:staging_area))
  end

  test "should show staging_area" do
    get :show, :id => staging_areas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => staging_areas(:one).to_param
    assert_response :success
  end

  test "should update staging_area" do
    put :update, :id => staging_areas(:one).to_param, :staging_area => { }
    assert_redirected_to staging_area_path(assigns(:staging_area))
  end

  test "should destroy staging_area" do
    assert_difference('StagingArea.count', -1) do
      delete :destroy, :id => staging_areas(:one).to_param
    end

    assert_redirected_to staging_areas_path
  end
end
