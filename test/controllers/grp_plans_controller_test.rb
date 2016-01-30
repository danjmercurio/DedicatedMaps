require 'test_helper'

class GrpPlansControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grp_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grp_plan" do
    assert_difference('GrpPlan.count') do
      post :create, :grp_plan => { }
    end

    assert_redirected_to grp_plan_path(assigns(:grp_plan))
  end

  test "should show grp_plan" do
    get :show, :id => grp_plans(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grp_plans(:one).to_param
    assert_response :success
  end

  test "should update grp_plan" do
    put :update, :id => grp_plans(:one).to_param, :grp_plan => { }
    assert_redirected_to grp_plan_path(assigns(:grp_plan))
  end

  test "should destroy grp_plan" do
    assert_difference('GrpPlan.count', -1) do
      delete :destroy, :id => grp_plans(:one).to_param
    end

    assert_redirected_to grp_plans_path
  end
end
