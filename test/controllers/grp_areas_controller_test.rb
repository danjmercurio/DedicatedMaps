require 'test_helper'

class GrpAreasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grp_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grp_area" do
    assert_difference('GrpArea.count') do
      post :create, :grp_area => { }
    end

    assert_redirected_to grp_area_path(assigns(:grp_area))
  end

  test "should show grp_area" do
    get :show, :id => grp_areas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grp_areas(:one).to_param
    assert_response :success
  end

  test "should update grp_area" do
    put :update, :id => grp_areas(:one).to_param, :grp_area => { }
    assert_redirected_to grp_area_path(assigns(:grp_area))
  end

  test "should destroy grp_area" do
    assert_difference('GrpArea.count', -1) do
      delete :destroy, :id => grp_areas(:one).to_param
    end

    assert_redirected_to grp_areas_path
  end
end
