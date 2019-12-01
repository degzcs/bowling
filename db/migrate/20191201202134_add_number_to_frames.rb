class AddNumberToFrames < ActiveRecord::Migration[5.1]
  def change
    add_column :frames, :number, :integer
  end
end
