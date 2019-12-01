class Game < ApplicationRecord

  #
  # Associations
  #

  has_many :frames
  has_many :players, -> { distinct }, through: :frames
end

