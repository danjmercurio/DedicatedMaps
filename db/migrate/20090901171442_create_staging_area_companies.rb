class CreateStagingAreaCompanies < ActiveRecord::Migration
  def self.up
    create_table :staging_area_companies do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :staging_area_companies
  end
end
