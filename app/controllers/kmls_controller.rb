class KmlsController < ApplicationController
  before_filter :ensure_super
  # skip_before_filter :maintain_session_and_user, :only => [:create]
  # skip_before_filter :subdomain_redirect, :only => [:create]
  def index
    @layer = Layer.find(params[:layer_id])
    redirect_to edit_layer_path(@layer) + '#kmls'
  end


  # POST /kmls
  def create
    @layer = Layer.find(params[:layer_id])
    @kml = @layer.kmls.new(params[:kml])
    
    if @kml.kml_file.present?
      # Encoding issues here with filename.
      @kml.url = @kml.kml_file.url.force_encoding("UTF-8")
    end
      
    if @kml.active == nil
      @kml.active = 0
    end

    respond_to do |format|
      if @kml.save
        @kml = Kml.new
      else
        flash[:notice] = 'Error saving kml data.'
      end
      format.html {redirect_to edit_layer_path(@layer) + '#kmls'}
      format.json {render json: @kml}
    end
  end
  
  # PUT /kmls/1
  def update
    @kml = Kml.find(params[:id])
    @layer = @kml.layer
    respond_to do |format|
      if @kml.update_attributes(params[:kml])
        @kml = Kml.new
      else
        flash[:notice] = 'Error saving kml data.'
      end
       format.js  {render :partial => 'layers/kml', 
                           :locals  => {:layer => @layer, 
                                        :kml => @kml 
                                } }
      format.html {redirect_to edit_layer_path(@layer) + '#kmls'}
    end
   
  end
  
  def destroy
    # @kml = Kml.find(params[:id])
    # @kml.destroy
    # @layer = @kml.layer
    # @kml = Kml.new
    # respond_to do |format|
    #   format.js  {render :partial => 'layers/kml', 
    #                      :locals  => {:layer => @layer, 
    #                                   :kml => @kml 
    #                           } }
    # end
    @kml = Kml.find(params[:id])
    @layer = @kml.layer
    @kml.destroy
    respond_to do |format| 
      format.html {
        redirect_to edit_layer_path(@layer) + '#kmls'
      }
    end
  end
end