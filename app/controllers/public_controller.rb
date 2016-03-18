class PublicController < ApplicationController

  def index
    render :action => params[:page]
  end

  def show
    render :action => params[:page]
  end

end