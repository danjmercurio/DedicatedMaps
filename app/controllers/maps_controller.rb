class MapsController < ApplicationController
  # skip_before_filter :subdomain_redirect
  before_filter :handle_public_map, :only => [:show, :update]
  before_filter :ensure_login, :only => [:show, :update]


  # GET /maps/1
  def show

    if !@map
      error_404
      return
    end

    # if the public map user is deactivated, go to a 404. deactivated private map user accounts won't get this far as they are not allowed to log in
    if !@map.user.active
      error_404
      return
    end

    # only show private maps to owners and admins/supers
    if (@map.user.privilege.name != 'public') && !(@owner_viewing || @admin_viewing)
      error_404
      return
    end

    case request.host
      when /dedicatedmaps\.com/
        @api_key = "ABQIAAAA6xOuv2QGCSYzQgWeyPIjOhRr3Xd4xZjf5YJPmwPMH3QxtdHmFxRs3Npod161i9oJvt4kMesPdIAMAw"
      when "ddstaging.heroku.com"
        @api_key = "ABQIAAAAy69Odjt6Lf7nfkVr1cc4RhSzNMyMG7jfrbNscvFG6hBDZlGADBRNwLOAGfXhUYgql8jmNsoBOFVj9g"
      when "ddmaps.heroku.com"
        @api_key = "ABQIAAAA6xOuv2QGCSYzQgWeyPIjOhTb1qRTpUuSAcKQhdyRJya1egF_zRSqOHrCfMTmOB1ZLxuSchOtrDMxlQ"
      else
        # @api_key = "ABQIAAAAy69Odjt6Lf7nfkVr1cc4RhTxgN00p8rVxP_i_AEKnk5cI5RjvBTIchKMP8bzQ5HpOlpV9TiYOs9K5w"
        @api_key = "AIzaSyDtLnlTZWqr9flex2_9RZD9HuZy0kNnI78" # Updated development key -ds
    end
    
    # Restrict layers to those enabled by both client and user.
    @layers = @map.user.client.layers.all(:order => :sort) & @map.user.layers.all

    @layer_config = Hash.new()
    @layers.each do |y|
      @layer_config[y.name] = {
        :type => y.category,
        :icon => y.icon,
      }
    end

    respond_to do |format|
      format.html
    end
  end

  # PUT /maps/1
  def update
    err = "Error saving map."
    
    if !@map
      render :text => err + ' 1'
      return
    end 

    #map edit privileges
    unless @owner_viewing || @admin_viewing
      render :text => err + ' 2'
      return
    end

    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.js { render :text =>  "#{@map.updated_at.strftime("Saved: %I:%M:%S %p %Z")}" }
      else
        format.js { render :text =>  err }
      end
    end
  end

  private 

  def handle_public_map
    @map = Map.find_by_id(params[:id].to_i)
    
    if !@map
      error_404
      return
    end
       
    # check if this is a public map viewing. If so, log user in as anonymous (public map)
    if !@loggedin_user && @map
      @session = Session.new
      @session.user_id = @map.user.id
      
      # save with validation is deprecated in rails 3
      #@session.save_with_validation(false)
      @session.save({
      	validate: false
      })


      @loggedin_user = @map.user
      @anonymous_user = true
      session[:id] = @session.id
    end

    # save button: (admin_viewing)
    #   super viewing public
    #   admin viewing public
    #   super viewing private
    #   admin viewing private
    # 
    # auto save: (ownder_viewing)
    #   user viewing private
    # 
    # nothing: (anonymous_user)
    #   public viewing public
    
    @owner_viewing = !@anonymous_user && @loggedin_user.is?(@map.user)
    @admin_viewing = !@anonymous_user && !@loggedin_user.is?(@map.user) && @loggedin_user.admin_for?(@map.user)
  end

end