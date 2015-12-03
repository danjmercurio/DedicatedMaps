class PrivateController < ApplicationController
  before_filter :ensure_login, :only => [:stats, :show]
  before_filter :ensure_logout, :only => []

  def index
    # render the landing page
  end

  def show
    render :action => params[:page]
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