class AisFeedsController < ApplicationController

  skip_before_action :verify_authenticity_token
  #  Test locally:
  #  curl http://0.0.0.0:3000/ais_feeds/ais1 -H "Content-type: application/json" -d "@test/files/ais/ais1.json"
  #  curl http://0.0.0.0:3000/ais_feeds/ais5 -H "Content-type: application/json" -d "@test/files/ais/ais5.json"

  def ais1
    ais1 = params[:ais1]
    # Verify the uploaded file exists as a parameter, that it is a file, and that it is not empty
    if ais1.present? && ais1.length > 0 && !ais1.blank?
      AisFeed.ais1 = ais1
      render :text => 'OK'
    else
      render :text => 'Error: AIS JSON data was not received, was malformed or was empty.', :status => 500
    end
  end
  
  def ais5
    ais5 = params[:ais5]
    # Verify the uploaded file exists as a parameter, that it is a file, and that it is not empty
    if ais5.present? && ais5.length > 0 && !ais5.blank?
      AisFeed.ais5 = ais5
      render :text => 'OK'
    else
      render :text => 'Error: file was not received, was malformed, or was empty.', :status => 500
    end
  end

end