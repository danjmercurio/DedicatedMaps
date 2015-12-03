# Seeds causing issues. These are located in seeds.rb anyway. Removing
# -Dan Schuman 2013 Jan 11

class SeedStagingAreaCompanies < ActiveRecord::Migration
  def self.up
    add_column :staging_area_companies, :title, :string
    # StagingAreaCompany.create(:name => 'crc' , :title => 'Clean Rivers Cooperative')
    # StagingAreaCompany.create(:name => 'mfsa' , :title => 'Marine Fire $ Safety Assoc.')
    # StagingAreaCompany.create(:name => 'poi' , :title => 'Points Of Interest')
  end

  def self.down
    remove_column :staging_area_companies, :title
    # StagingAreaCompany.find_by_name('crc').destroy
    # StagingAreaCompany.find_by_name('mfsa').destroy
    # StagingAreaCompany.find_by_name('poi').destroy
  end
end
