class AisFeedsController < ApplicationController

  skip_before_action :verify_authenticity_token
  #  Test locally:
  #  curl http://0.0.0.0:3000/ais_feeds/ais1 -H "Content-type: application/json" -d "@test/files/ais/ais1.json"
  #  curl http://0.0.0.0:3000/ais_feeds/ais5 -H "Content-type: application/json" -d "@test/files/ais/ais5.json"

  def ais1
    AisFeed.ais1 = params[:ais1]
    render :text => "OK"
  end
  
  def ais5
    AisFeed.ais5 = params[:ais5]
    render :text => "OK"
  end

end