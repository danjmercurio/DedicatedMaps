class PrivateController < ApplicationController
  # before_filter :ensure_login #, :only => [:stats, :show]
  # before_filter :ensure_logout, :only => []
  before_action :authenticate_user!


  def index
    # render the landing page
  end

  def show
    # Non-superusers are not allowed to view admin page
    if params[:page] == "admin" && !@loggedin_user.super?
      logout_user
      redirect_to '/'
      flash[:error] = 'Please login to continue'
    else
      render :action => params[:page]
    end
  end

  #GET /home/stats
  def stats
    if !@loggedin_user.super?
       error_404
    else
      ## generate stats here. I'm guessing we'll have a bunch of custom queries...
     @user_count = User.all.length
    end
  end

end