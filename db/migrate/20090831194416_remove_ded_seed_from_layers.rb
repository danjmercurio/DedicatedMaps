# Check for nils on migrating from empty DB
# -Dan Schuman 2013 Jan 11

class RemoveDedSeedFromLayers < ActiveRecord::Migration
  def self.up
    # ded = Layer.find_by_name("ded")
    # ded.destroy if ded
  end

  def self.down
    # Layer.create(:name=>'ded', :title=>'Dedicated Ships')
  end
end
