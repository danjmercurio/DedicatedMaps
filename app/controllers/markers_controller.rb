class MarkersController < StagingAreasController

  def show
    # If a layer doesn't have a controller, override it here
    layer = Layer.find_by_name(params[:name])
    params[:name] = 'staging_areas' if layer.staging_area_company
    
    redirect_to("/#{params[:name]}/#{params[:id]}.#{params[:format]}")
  end
    
end