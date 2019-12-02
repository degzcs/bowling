class AddStrikeAndSpareToFrames < ActiveRecord::Migration[5.1]
  def change
    add_column :frames, :strike, :boolean, default: false
    add_column :frames, :spare, :boolean, default: false
  end
end
