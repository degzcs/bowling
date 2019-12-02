class AddRoundToFrames < ActiveRecord::Migration[5.1]
  def change
    add_column :frames, :round, :integer, default: 0
  end
end
