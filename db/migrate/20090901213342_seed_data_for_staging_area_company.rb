class SeedDataForStagingAreaCompany < ActiveRecord::Migration
  def self.up
    # StagingAreaCompany.create(:name => "CRC")
    # StagingAreaCompany.create(:name => "MFSA")
    # StagingAreaCompany.create(:name => "POI")
  end

  def self.down
    # StagingAreaCompany.find_by_name("CRC").destroy()
    # StagingAreaCompany.find_by_name("MFSA").destroy()
    # StagingAreaCompany.find_by_name("POI").destroy()
  end
end
