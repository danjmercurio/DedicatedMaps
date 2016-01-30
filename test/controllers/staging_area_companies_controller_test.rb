require 'test_helper'

class StagingAreaCompaniesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staging_area_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staging_area_company" do
    assert_difference('StagingAreaCompany.count') do
      post :create, :staging_area_company => { }
    end

    assert_redirected_to staging_area_company_path(assigns(:staging_area_company))
  end

  test "should show staging_area_company" do
    get :show, :id => staging_area_companies(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => staging_area_companies(:one).to_param
    assert_response :success
  end

  test "should update staging_area_company" do
    put :update, :id => staging_area_companies(:one).to_param, :staging_area_company => { }
    assert_redirected_to staging_area_company_path(assigns(:staging_area_company))
  end

  test "should destroy staging_area_company" do
    assert_difference('StagingAreaCompany.count', -1) do
      delete :destroy, :id => staging_area_companies(:one).to_param
    end

    assert_redirected_to staging_area_companies_path
  end
end
