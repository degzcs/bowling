class AddKnockedPins3ToFrames < ActiveRecord::Migration[5.1]
  def change
    add_column :frames, :knocked_pins3, :integer, default: 0
  end
end
