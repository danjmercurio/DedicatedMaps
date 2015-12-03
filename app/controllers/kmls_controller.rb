class KmlsController < ApplicationController
  before_filter :ensure_super
  
  def index
    redirect_to edit_layer_path(@layer) + '#kmls'
  end


  # POST /kmls
  def create
    @layer = Layer.find(params[:layer_id])
    @kml = @layer.kmls.build(params[:kml])
    
    if uploaded_file = params[:kml_file]
      @kml.stored_file = StoredFile.create(:binary_data => uploaded_file.read, :content_type => uploaded_file.content_type.chomp)
      @kml.url = uploaded_file.original_filename
    end
      
    respond_to do |format|
      if @kml.save
        @kml = Kml.new
      else
        flash[:notice] = 'Error saving kml data.'
      end
      format.html {redirect_to edit_layer_path(@layer) + '#kmls'}
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
    end
   
  end
  
  def destroy
    @kml = Kml.find(params[:id])
    @kml.destroy
    @layer = @kml.layer
    @kml = Kml.new
    respond_to do |format|
      format.js  {render :partial => 'layers/kml', 
                         :locals  => {:layer => @layer, 
                                      :kml => @kml 
                              } }
    end
  end
end