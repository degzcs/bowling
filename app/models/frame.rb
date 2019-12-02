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

  def beginning_of_the_frame?
    self.round == 0
  end

  def first_round?
    self.round == 1
  end

  def second_round?
    self.round == 2
  end

  def finished?
    self.strike? ||
    (self.spare? && self.first_round?) ||
    self.second_round?
  end

  def tenth?
    self.number == 10
  end
end
