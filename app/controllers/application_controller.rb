# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include ExceptionNotifiable
  
  #helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :maintain_session_and_user
  before_filter :subdomain_redirect

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3ef815416f775098fe977004015c6193'

  def ensure_login
    unless @loggedin_user
      session[:target] = params
      flash[:notice] = "Please login to continue"
      redirect_to('/public/index')
    end
  end

  def ensure_logout
    if @loggedin_user
      flash[:notice] = "You must logout before you can login or register"
      redirect_to('/public/index')
    end
  end

  def ensure_super
    unless @loggedin_user && @loggedin_user.super?
      session[:target] = params
      flash[:notice] = "Please login to continue"
      redirect_to('/public/index')
    end
  end
  
  def logout_user
    # Session.destroy(@application_session)
    Session.destroy(params[:id]) if params[:id]
    session[:id] = @loggedin_user = @anonymous_user = nil
  end
  helper_method :logout_user

  def error_404
    render :file => "#{Rails.root}/public/404", :status => 404, :layout => 'public', :formats => [:html]
  end

  private

  def subdomain_redirect
    subdomain = request.subdomains.join('') #we only consider one level of subdomains
    if subdomain == 'www'
      redirect_to "http://#{request.domain}:#{request.port}#{request.path}"
    elsif subdomain == 'ddstaging'
      render '/public/index', :layout => 'public' if request.path == '/'
    elsif !subdomain.blank?
      user = User.find_by_username(subdomain)
      if !user.nil? && request.path == '/'
        params[:id] = user.map.id
        redirect_to "http://#{request.domain}:#{request.port}" + maps_path + "/" + user.map.id.to_s
      else
        error_404
      end
    elsif request.path == '/'
      render '/public/index', :layout => 'public'
    end
  end

  def maintain_session_and_user
    if session[:id]
      if @application_session = Session.find_by_id(session[:id])
        @application_session.update_attributes(:ip_address => request.remote_addr, :path => request.path_info)
        @loggedin_user = @application_session.user
        Time.zone = @loggedin_user.time_zone
        if @loggedin_user.privilege.name == 'public'
           @anonymous_user = true
           @session = Session.new
        end
      else
        session[:id] = nil
        redirect_to('/public/index')
      end
    else
      @session = Session.new
    end
  end
end