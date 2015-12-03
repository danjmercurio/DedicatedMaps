class StoredFilesController < ApplicationController

  def show    
    file = StoredFile.find params[:id]
    # TODO: enable stored KML/Z files to be requested by users of a specific client only
    # if @loggedin_user.client == file.client
      send_data file.binary_data, :file_name => file.filename, :type => file.content_type
    # else
    #   render :file => "public/401.html", :status => :unauthorized
    # end
  end

end