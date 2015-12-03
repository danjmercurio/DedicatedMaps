class PublicController < ApplicationController
  before_filter :ensure_login, :only => []
  before_filter :ensure_logout, :only => []

  def index
    render :action => params[:page]
  end

  def show
    render :action => params[:page]
  end

end