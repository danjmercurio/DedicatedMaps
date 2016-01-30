require 'test_helper'

class LayersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:layers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create layers" do
    assert_difference('Layers.count') do
      post :create, :layers => { }
    end

    assert_redirected_to layers_path(assigns(:layers))
  end

  test "should show layers" do
    get :show, :id => layers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => layers(:one).to_param
    assert_response :success
  end

  test "should update layers" do
    put :update, :id => layers(:one).to_param, :layers => { }
    assert_redirected_to layers_path(assigns(:layers))
  end

  test "should destroy layers" do
    assert_difference('Layers.count', -1) do
      delete :destroy, :id => layers(:one).to_param
    end

    assert_redirected_to layers_path
  end
end
