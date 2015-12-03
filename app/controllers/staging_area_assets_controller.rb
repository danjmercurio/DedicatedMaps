class StagingAreaAssetsController < ApplicationController
  # GET /staging_area_asset/1.json
  def show
    @staging_area_asset = StagingAreaAsset.find(params[:id])

    respond_to do |format|
      format.json  {
        render :json => @staging_area_asset.to_json(
          :except => [:staging_area_asset_type_id, :staging_area_id],
          :include => {
            :staging_area_asset_details => {
              :only => [:name, :value]
            },
            :staging_area_asset_type => {
              :only => :name,
              :include => {
                :staging_area_company => {
                  :include => {
                    :layer => { :only => :name }
                  }
                }
              }
            },
            :staging_area_assets => {
              :only     => [:description, :id],
              :include  => {
                :staging_area_asset_type => {:only => :name}  # TODO: This is pretty smelly 
              }
            }
          }
        )
      }
    end
  end
end
