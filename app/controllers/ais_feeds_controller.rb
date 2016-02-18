class AisFeedsController < ApplicationController

  skip_before_action :verify_authenticity_token
  #  Test locally:
  #  curl http://0.0.0.0:3000/ais_feeds/ais1 -H "Content-type: application/json" -d "@test/files/ais/ais1.json"
  #  curl http://0.0.0.0:3000/ais_feeds/ais5 -H "Content-type: application/json" -d "@test/files/ais/ais5.json"

  def ais1
    ais1 = params[:ais1]
    # Verify the uploaded file exists as a parameter, that it is a file, and that it is not empty
    if ais1.present? && ais1.class.name == "ActionDispatch::Http::UploadedFile" && !ais1.blank?
      if ais1.content_type == "application/json"
        # Get the raw uploaded file
        aisData = ais1.tempfile.read
        # Strip any newline characters or whitespace
        aisData.squish!
        aisData.delete!("\\")

        AisFeed.ais1 = aisData
        render :text => "OK"
      else
        render :text => "Error: file received was not of type 'application/json'"
      end
    else
      render :text => "Error: file was not received, or was empty."
    end
  end
  
  def ais5
    ais5 = params[:ais5]
    if ais5.present? && ais5.class.name == "ActionDispatch::Http::UploadedFile" && !ais5.blank?
      if ais5.content_type == "application/json"
        aisData = ais5.tempfile.read
        aisData.squish!
        aisData.delete("\\")

        AisFeed.ais5 = aisData
        render :text => "OK"
      else
        render :text => "Error: file received was not of type 'application/json'"
      end
    else
      render :text => "Error: file was not received, or was empty."
    end
  end

end