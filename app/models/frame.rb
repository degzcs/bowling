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

  validates :knocked_pins1, numericality: { less_than_or_equal_to: Frame::MAX_PINS }
  validates :knocked_pins2, numericality: { less_than_or_equal_to: Frame::MAX_PINS }

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

  def third_round?
    self.round == 3
  end

  def finished?
    strike_finished? ||
      spare_finished? ||
      regular_finished?
  end

  def strike_finished?
    tenth? ? (self.strike && third_round?) : self.strike
  end

  def spare_finished?
    tenth? ? (self.spare && second_round?) : (self.spare && self.first_round?)
  end

  def regular_finished?
    self.second_round? && !self.strike && !self.spare
  end

  def tenth?
    self.number == 10
  end
end
