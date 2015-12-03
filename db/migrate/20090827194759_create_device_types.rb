class CreateDeviceTypes < ActiveRecord::Migration
  def self.up
    create_table :device_types do |t|
      t.string :name
      t.text :description
    end
    # DeviceType.create(:name => 'AIS')
    # DeviceType.create(:name => 'SPOT')
    # DeviceType.create(:name => 'Guardian Mobility SEATrack')
    # DeviceType.create(:name => 'Guardian Mobility Tracer')
    # DeviceType.create(:name => 'Guardian Mobility SkyTrack')
    # DeviceType.create(:name => 'VMS Faria WatchDog')
  end

  def self.down
    drop_table :device_types
  end
end
