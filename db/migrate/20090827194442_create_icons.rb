class CreateIcons < ActiveRecord::Migration
  def self.up
    create_table :icons do |t|
      t.integer :asset_type_id
      t.string :name, :suffix
    end
    # Icon.create(:name => 'Passenger', :suffix => 'Pas')
    # Icon.create(:name => 'Cargo', :suffix => 'Car')
    # Icon.create(:name => 'Tanker', :suffix => 'Tan')
    # Icon.create(:name => 'High Speed Craft', :suffix => 'HSC')
    # Icon.create(:name => 'Tug', :suffix => 'Tug')
    # Icon.create(:name => 'Pilot', :suffix => 'Plt')
    # Icon.create(:name => 'Yachts', :suffix => 'Yct')
    # Icon.create(:name => 'Anti Polution Equipment', :suffix => 'APE')
    # Icon.create(:name => 'Unspecified', :suffix => 'Uns')
    # Icon.create(:name => 'Towing', :suffix => 'Tow')
    # Icon.create(:name => 'Fishing', :suffix => 'Fsh')
    # Icon.create(:name => 'Military/Law Enforcement', :suffix => 'Mil')
    # Icon.create(:name => 'Dredging', :suffix => 'Drg')
  end

  def self.down
    drop_table :icons
  end
end
