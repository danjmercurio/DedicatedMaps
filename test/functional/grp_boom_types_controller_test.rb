require 'test_helper'

class GrpBoomTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grp_boom_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grp_boom_type" do
    assert_difference('GrpBoomType.count') do
      post :create, :grp_boom_type => { }
    end

    assert_redirected_to grp_boom_type_path(assigns(:grp_boom_type))
  end

  test "should show grp_boom_type" do
    get :show, :id => grp_boom_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grp_boom_types(:one).to_param
    assert_response :success
  end

  test "should update grp_boom_type" do
    put :update, :id => grp_boom_types(:one).to_param, :grp_boom_type => { }
    assert_redirected_to grp_boom_type_path(assigns(:grp_boom_type))
  end

  test "should destroy grp_boom_type" do
    assert_difference('GrpBoomType.count', -1) do
      delete :destroy, :id => grp_boom_types(:one).to_param
    end

    assert_redirected_to grp_boom_types_path
  end
end
