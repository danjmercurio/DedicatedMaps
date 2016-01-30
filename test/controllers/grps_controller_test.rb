require 'test_helper'

class GrpsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grp" do
    assert_difference('Grp.count') do
      post :create, :grp => { }
    end

    assert_redirected_to grp_path(assigns(:grp))
  end

  test "should show grp" do
    get :show, :id => grps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grps(:one).to_param
    assert_response :success
  end

  test "should update grp" do
    put :update, :id => grps(:one).to_param, :grp => { }
    assert_redirected_to grp_path(assigns(:grp))
  end

  test "should destroy grp" do
    assert_difference('Grp.count', -1) do
      delete :destroy, :id => grps(:one).to_param
    end

    assert_redirected_to grps_path
  end
end
