class VisibilitySeedPopulate < ActiveRecord::Migration
  def self.up
    # Visibility.create(:name=>"Hidden", :description => "Invisible to all viewers including owner.")
    # Visibility.create(:name=>"Private", :description => "Visible only to owner.")
    # Visibility.create(:name=>"Shared", :description => "Visible to owner and asset share list.") 
    # Visibility.create(:name=>"Public", :description => "Visible to public.")
  end

  def self.down
    # Visibility.all.each do |v| 
    #   v.destroy
    # end
  end
end
