class ChangeLicenseDeactivateToDeactivated < ActiveRecord::Migration
  def self.up
    rename_column(:licenses, :deactivate, :deactivated)
  end

  def self.down
    rename_column(:licenses, :deactivated, :deactivate)
  end
end
