class Frame < ApplicationRecord
  PER_GAME = 10
  MAX_PINS = 10

  #
  # Associations
  #

  belongs_to :player
  belongs_to :game

  #
  # Validations
  #

  validates :knocked_pins1, numericality: { less_than: Frame::MAX_PINS }
  validates :knocked_pins2, numericality: { less_than: Frame::MAX_PINS }

  #
  # Instance Methods
  #

  def first_round?
    self.knocked_pins1 == 0
  end

  def finished?
    self.knocked_pins2 != 0
  end
end
