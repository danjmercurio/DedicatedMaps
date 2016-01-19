class LicensesController < ApplicationController
  respond_to :html, :js, :json
  before_filter :ensure_login, :only => [:create, :activate]
  before_filter :ensure_logout, :only => []

  # POST /licenses
  # POST /licenses.xml
  def create
  @client = Client.find(params[:client_id])
  @license = @client.licenses.build(user_params)
  @license.user_id = @loggedin_user.id
  
      if @license.save
        # flash[:notice] = 'License was successfully created.'
        #format.html { redirect_to(@client) }
        #format.xml  { render :xml => @license, :status => :created, :location => @license }
        redirect_to :back
      else
        flash[:error] = @license.errors.full_messages.to_sentence
        #format.html { redirect_to(@client) }
        #format.xml  { render :xml => @license.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page| 
          page.redirect_to @client 
        end
      end
    end
  end
  
# AJAX POST /license/activate
  def activate
     license = License.find(params[:id])
     
     if license.update_attribute(:deactivated, !license.deactivated)
       if license.deactivated
          message = "no"
        else
          message = "yes"     
        end
     else
       message = "Error: License activation not changed"
     end
     
    respond_to do |format|
      format.js { render :text =>  message }
    end
  end 

private

def user_params
  params.require(:license).permit(:expires(1i), :expires(2i), :expires(3i))
end

end