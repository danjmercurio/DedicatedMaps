class SessionsController < ApplicationController
  
  before_filter :ensure_login, :only => :destroy
  before_filter :ensure_logout, :only => [:create, :recovery]

  def show
    redirect_to :back
  end

  def index
    redirect_to :back
  end

  def create
    @session = Session.new(user_params)
    if @session.save
      if !@session.user.has_license?
       flash[:notice] = "User license is expired."
       redirect_to :back
      elsif !@session.user.account_active?
       flash[:notice] = "This user account is currently disabled."
       redirect_to :back
      else
       session[:id] = @session.id
       @session.user.update_attribute(:last_login, Time.now)
       if false #session[:target]
         redirect_to session[:target]
         session[:target] = nil
       else
         redirect_to(map_path(@session.user.map))
       end      
      end
    else
      flash[:notice] = "Login failed. Please try again."
      redirect_to :back
    end
  end
  
  def update
    #called by public map only
    session[:target] = request.env['HTTP_REFERER']
    create
  end

  def delete
    destroy
  end

  def destroy
    logout_user
    redirect_to '/'
    flash[:notice] = 'You are now logged out.'
  end
  
  def recovery
    begin
      key = Crypto.decrypt(params[:id]).split(/:/)
      @user = User.find(key[0], :conditions => {:salt => key[1]})
      @session = @user.sessions.create
      session[:id] = @session.id
      flash[:notice] = "Please change your password"
      redirect_to(edit_user_path(@user))
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "The recovery link given is not valid"
      redirect_to '/'
    end
  end

  private

  def user_params
    params.require(:session).permit(:username, :password)
  end
end