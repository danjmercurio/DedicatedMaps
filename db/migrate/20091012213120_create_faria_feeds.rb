class CreateFariaFeeds < ActiveRecord::Migration
  def self.up
    create_table :faria_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :faria_feeds
  end
end
