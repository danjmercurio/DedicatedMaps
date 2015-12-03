class ChangeFacToFaxInStagingAreas < ActiveRecord::Migration
  def self.up
      rename_column :staging_areas, :fac, :fax
  end

  def self.down
     rename_column :staging_areas, :fax, :fac
  end
end
