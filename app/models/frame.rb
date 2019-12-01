class Frame < ApplicationRecord
  PER_GAME = 10

  #
  # Associations
  #

  belongs_to :player
  belongs_to :game
end
