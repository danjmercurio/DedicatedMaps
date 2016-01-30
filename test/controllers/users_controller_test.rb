require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
     @session = Session.create({:username => "dhollerich", :password => "DDhh2008"})

  end

  test "should get index" do
    @controller.maintain_session_and_user
    Rails::logger.debug(get :index)
    Rails::logger.debug(@loggedin_user)
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    @controller.maintain_session_and_user
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => { }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:one).to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => users(:one).to_param, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).to_param
    end

    assert_redirected_to users_path
  end
end
