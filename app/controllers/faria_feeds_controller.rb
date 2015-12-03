class FariaFeedsController < ApplicationController
before_filter :authenticate

  #POST /faria_feeds
  def create
    #@faria_feed = FariaFeed.new(params[:data])  
    
    logger.info( request.raw_post || "No data POSTed")

    respond_to do |format|
      if @is_authenticated
        #if @faria_feed.save
          format.html { render :text => "OK"}
        #end 
      else
        format.html { render :text => "Error" }
      end
 
    end
  end
  
  protected

  def authenticate
     @is_authenticated = authenticate_or_request_with_http_basic do |username, password|
      username == "faria" && password == "fio1stV2paf"
    end
  end

end