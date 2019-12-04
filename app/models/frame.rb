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
  validates :knocked_pins3, numericality: { less_than_or_equal_to: Frame::MAX_PINS }

  #
  # Callbacks
  #

  before_save :special_play?

  #
  # Instance Methods
  #

  def knocked_pins
    self.knocked_pins1 + self.knocked_pins2 + self.knocked_pins3
  end

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
    tenth? ? (self.spare && third_round?) : (self.spare && self.second_round?)
  end

  def regular_finished?
    self.second_round? && !self.strike && !self.spare
  end

  def tenth?
    self.number == 10
  end

  private

  def special_play?
    self.strike = self.knocked_pins1 == MAX_PINS if self.first_round?
    self.spare = (self.knocked_pins1 + self.knocked_pins2) == MAX_PINS if self.second_round?
  end
end
