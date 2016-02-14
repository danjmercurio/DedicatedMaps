class StagingAreasController < ApplicationController
  # GET /staging_areas
  # GET /staging_areas.xml
  def index
    if params[:id]
      @staging_areas = Layer.find_by_name(params[:id]).staging_area_company.staging_areas
    else
      @staging_areas = StagingArea.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staging_areas }
      format.json  { render :json => @staging_areas }
    end
  end

  # GET /staging_areas/1.json
  # return all staging areas that contain a specific equipment type.
  def search
  
    @company = Layer.find_by_name(params[:name]).staging_area_company

    # These named finders are deprecated in Rails 5
    # @staging_areas = StagingArea.find_all_by_staging_area_company_id(
    #   @company.id,
    #   :joins      => [:staging_area_assets],
    #   :conditions => ['staging_area_assets.staging_area_asset_type_id = ?', params[:id]]
    # ).each {|s| s.icon = 'teardrop/red-dot'}

    # @staging_areas = StagingArea.includes(:staging_area_assets)
    #    .where("staging_area_assets.staging_area_asset_type_id = ? AND staging_area_company_id = ?", params[:name], params[:id])
    #    .each {|s| s.icon = 'teardrop/red-dot'}

    # Deprecated finder
    # @all = StagingArea.find_all_by_staging_area_company_id(@company.id)

    @all = StagingArea.where(:staging_area_company_id => @company.id)
    @staging_areas = @all.joins(:staging_area_assets)
                         .where("staging_area_assets.staging_area_asset_type_id = ?", params[:id])
                         .each { |s| s.icon = 'teardrop/red-dot' }

    @all = (@all - @staging_areas) + @staging_areas

    respond_to do |format|
      format.json  { render :json => @all }
    end
  end
 
  # GET /staging_areas/1
  # GET /staging_areas/1.json
  def show
    @staging_area = StagingArea.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @staging_area.to_json(
        :except                 => [:staging_area_company_id],
        :include                => {
          :staging_area_company => {:only => :title},
          :staging_area_details => {:only => [:name, :value]},
          :staging_area_assets  => {
            :only               => [:description, :id],
            :include            => {
              :staging_area_asset_type => {:only => :name}
            }
          }
        }
        )
      }
     end
  end

end