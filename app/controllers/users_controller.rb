class UsersController < ApplicationController
  layout "private" 
  before_filter :ensure_login, :only => [:activate, :index, :new, :edit, :update, :create]
  before_filter :ensure_logout, :only => []

  # AJAX POST /users/recover
  def recover
    @user = User.find_by_username(params[:username])

    respond_to do |format|
      if @user
        RecoveryMailer.sendRecovery(:key => Crypto.encrypt("#{@user.id}:#{@user.salt}"),
        :email => @user.email,
        :domain => request.env['HTTP_HOST']).deliver
        format.js { render :text =>  "Password reset. User will be emailed instructions." }
        format.html {
          flash[:notice] = "Password reset. User will be emailed instructions."
          redirect_to :back
        }
      else
        format.html{
          flash[:notice] = "Error: account could not be found."
          redirect_to :back
        }
      format.js { render :text =>  "Error: account could not be found." }

      end
    end
  end

  #~ # AJAX POST /users/activate
  def activate
    user = User.find(params[:id])

    if user.update_attribute(:active, !user.active)
      if user.active
        message = "This account is currently enabled."
      else
        message = "This account is currently disabled."     
      end
    else
      message = "Error: User account activation not changed"
    end

    respond_to do |format|
      format.js { render :text =>  message }
      format.html{
          flash[:notice] = message
          redirect_to :back
        }
    end
  end

  #~ # GET /users
  def index
    pub = Privilege.find_by_name('public')
    if @loggedin_user.super?
      # RAILS 3 @users = User.all(:order => "client_id, last_name", :conditions => ['privilege_id <> ?', pub.id])
      @users = User.where('privilege_id <> :privilege_id', {privilege_id: pub.id})
    elsif @loggedin_user.admin?
      # Can only list users with the same client
      @users = User.find(:all,
      :conditions => [ "client_id = ? AND privilege_id <> ?", @loggedin_user.client_id, pub.id ],
      :order => "client_id, last_name")
    else 
      # standard users can't view user list
      error_404
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/new
  def new
    @user = User.new
    set_client_privilege
    @user.privilege_id = 3 # set the default privilege to "standard"
    # The layers allowed for the user defaults to the layers available to the admin
    # creating the user. If the loggedin_user is a super user, the layers
    # will update when the user updates the client menu.
    @layers = @loggedin_user.client.layers.all
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if @loggedin_user.admin_for?(@user)
      set_client_privilege
      @layers = @user.client.layers.all.order('created_at DESC')
    else
      error_404
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    set_client_privilege

    # If all checkboxes are unchecked, no params are sent.
    # To get around this we set a hidden param: layer_checkboxes.
    # If it is present and the checkbox values
    # are not, then we know to clear all of the layers.
    if params[:layer_checkboxes] && params[:user][:layer_ids].nil? 
      @user.remove_all_layers
    end

    respond_to do |format|
      # if the password was changed, make sure it matched in the confirmation field
      if params[:user][:password] && (params[:user][:password] != params[:user][:password_confirmation])
      	format.html {
          flash[:notice] = 'Error: Make sure both fields match when changing password.'
          redirect_to :back 
        }
        format.js { render :text =>  "Error: Make sure both fields match when changing password." }
      # if the password was changed, check the size
      elsif params[:user][:password] && params[:user][:password].size < 6
      	format.html {
          flash[:notice] = 'Error: Password must be at least 6 characters.'
          redirect_to :back 
        }
        format.js { render :text =>  "Error: Password must be at least 6 characters." }
      else
	    if @user.update_attributes!(params[:user])
	        format.html { 
	          flash[:notice] = 'User account was successfully updated.'
	          redirect_to :back
	        }
	        format.js { render :text =>  "User account successfully updated." }
	    else
	        format.html {
	          flash[:notice] = 'Error: User account was not successfully updated.'
	          redirect_to :back 
	        }
	        format.js { render :text =>  "Error: User account not updated." }
	      end
	    end
    end
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @pword = @user.temp_password
    @user.password = @pword
    if !@user.client_id
      @user.client_id = @loggedin_user.client_id
    end
    respond_to do |format|
      if @user.save
        # create a map for this user
        @map = Map.new(:user_id => @user.id)
        @map.save
        # Mailer.deliver_signup
        SignupMailer.signupMail(@user, @pword).deliver
        flash[:notice] = "Account for #{@user.first_name} #{@user.last_name} created. An invitation email was sent."
        format.html { redirect_to(:action => 'edit', :id => @user.id) }
      else
        set_client_privilege
        @layers = @user.client.layers.all(:order => :sort)
        format.html { render :action => "new" }
      end
    end
  end

  private

  def set_client_privilege
    if @loggedin_user.super?
      @clients = Client.all
      # RAILS 3 @privileges = Privilege.all(:order => "id DESC", :conditions => ['name <> (?)', 'public'])
      @privileges = Privilege.where('name <> :name', {name: 'public'}).order('id DESC')
    elsif @loggedin_user.admin?
      @privileges = Privilege.find(:all, :conditions => ["name NOT in (?)", ['super','public']])
      #Admins can't set anyone to be a super or public user.
    end
  end

end