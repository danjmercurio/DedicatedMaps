class StagingAreaCompaniesController < ApplicationController

  def update
    @staging_area_company = StagingAreaCompany.find(params[:id])

    respond_to do |format|
      if @staging_area_company.update_attributes(params[:staging_area_company])
        flash[:notice] = 'Staging Area Company was successfully updated.'
        format.html { redirect_to(layers_url) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Error: Layer not successfully updated.'
        format.html { render :controller => "layers", :action => "edit" }
      end
    end
  end

end