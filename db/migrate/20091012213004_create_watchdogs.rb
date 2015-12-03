class CreateWatchdogs < ActiveRecord::Migration
  def self.up
    create_table :watchdogs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :watchdogs
  end
end
