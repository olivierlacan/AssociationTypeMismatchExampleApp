class AddPredecessorIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :predecessor_id, :integer
  end
end
