class LayersController < ApplicationController
  layout "private"
  before_filter :ensure_super

  # GET /layers
  # GET /layers.xml
  def index
    @layers = Layer.all(:order => :sort)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @layer }
    end
  end

  # GET /grps/1
  # GET /grps/1.xml
  def show
    @layer = Layer.find(params[:id])

    respond_to do |format|
      #format.html # show.html.erb
      format.json  { render :json => @layer }
      format.xml  { render :xml => @layer }
    end
  end

  # GET /layer/new
  # GET /layer/new.xml
  def new
    @layer = Layer.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @layer }
    end
  end

  # GET /layer/1/edit
  def edit
    @layer = Layer.find(params[:id])
    if @layer.category == "StagingArea"
      @staging_area_company = @layer.staging_area_company
    end
    if @layer.category == "KML"
      @kml = Kml.new
      @stored_file = StoredFile.new
    end
  end

  # POST /layer
  def create
    @layer = Layer.new(params[:layer])
    if !@layer.save
      render :action => "new"
      return
    end
    
    if @layer.category == "StagingArea"
      StagingAreaCompany.create(:layer_id => @layer.id)
    end

    flash[:notice] = 'Layer was successfully created.'
    if @layer.category == 'custom'
      redirect_to(layers_url)
    else
      redirect_to(edit_layer_url(@layer))
    end
  end

  # PUT /layer/1
  # PUT /layer/1.xml
  def update
    @layer = Layer.find(params[:id])

    respond_to do |format|
      if @layer.update_attributes(params[:layer])
        flash[:notice] = 'Layer was successfully updated.'
        format.html { redirect_to(layers_url) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Error: Layer not successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @layer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /layer/1
  # DELETE /layer/1.xml
  def delete
    @layer = Layer.find(params[:id])
    @layer.destroy

    respond_to do |format|
      format.html { redirect_to(layers_url) }
      format.xml  { head :ok }
    end
  end
end
