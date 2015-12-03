require 'test_helper'

class GrpBoomsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grp_booms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grp_boom" do
    assert_difference('GrpBoom.count') do
      post :create, :grp_boom => { }
    end

    assert_redirected_to grp_boom_path(assigns(:grp_boom))
  end

  test "should show grp_boom" do
    get :show, :id => grp_booms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grp_booms(:one).to_param
    assert_response :success
  end

  test "should update grp_boom" do
    put :update, :id => grp_booms(:one).to_param, :grp_boom => { }
    assert_redirected_to grp_boom_path(assigns(:grp_boom))
  end

  test "should destroy grp_boom" do
    assert_difference('GrpBoom.count', -1) do
      delete :destroy, :id => grp_booms(:one).to_param
    end

    assert_redirected_to grp_booms_path
  end
end
