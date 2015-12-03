require 'test_helper'

class MapAreasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:map_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create map_area" do
    assert_difference('MapArea.count') do
      post :create, :map_area => { }
    end

    assert_redirected_to map_area_path(assigns(:map_area))
  end

  test "should show map_area" do
    get :show, :id => map_areas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => map_areas(:one).to_param
    assert_response :success
  end

  test "should update map_area" do
    put :update, :id => map_areas(:one).to_param, :map_area => { }
    assert_redirected_to map_area_path(assigns(:map_area))
  end

  test "should destroy map_area" do
    assert_difference('MapArea.count', -1) do
      delete :destroy, :id => map_areas(:one).to_param
    end

    assert_redirected_to map_areas_path
  end
end
