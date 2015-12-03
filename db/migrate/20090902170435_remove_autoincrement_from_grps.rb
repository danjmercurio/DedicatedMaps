class RemoveAutoincrementFromGrps < ActiveRecord::Migration
  def self.up
    create_table "grp_plans", :force => true, :id => false do |t|
      t.integer "id"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    remove_column :grp_plans, :id
  end
end
