class CustomFieldsController < ApplicationController
  before_filter :ensure_super
  
  def index
    redirect_to :back
  end

  # POST /custom_fields
  def create
    @asset = Asset.find(params[:asset][:id])
    @custom_field = @asset.custom_fields.build(params[:custom_field])
  
    respond_to do |format|
      if @custom_field.save
        flash[:notice] = 'Field data was successfully saved.'
        @custom_field = CustomField.new
      else
        flash[:notice] = 'Error saving field data.'
      end
          
      format.html {redirect_to :back}
      format.js  {render :partial => 'assets/fields', 
                         :locals  => {:asset => @asset, 
                                      :custom_field => @custom_field
                  } }
    end
  end
  
  # PUT /custom_fields/1
  def update
    @custom_field = CustomField.find(params[:id])
      if @custom_field.update_attributes(params[:custom_field])
        flash[:notice] = 'Field data was successfully saved.'
        
      else
        flash[:notice] = 'Error saving field data.'
      end
      respond_to do |format| 
          format.html {redirect_to :back} 
          format.js  {render :partial => 'assets/fields', 
                             :locals  => {:asset => @asset, 
                                          :custom_field => @custom_field
                      } }
      end
  end
  
  def destroy
    @custom_field = CustomField.find(params[:id])
    @asset = @custom_field.asset
    @custom_field.destroy
    @custom_field = CustomField.new
    flash[:notice] = 'Field data was successfully deleted.'
    respond_to do |format|
      format.html {redirect_to :back}
      format.js  {render :partial => 'assets/fields', 
                         :locals  => {:asset => @asset, 
                                      :custom_field => @custom_field 
                              } }
    end
  end
  
end