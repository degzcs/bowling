class EnterKnockedPins < ActiveModelService
  attr_reader :frame, :knocked_pins, :round

  def initialize
  end

  def call(game_id:, player_id:, frame_number:, knocked_pins:, round:)
     ActiveRecord::Base.transaction do
      @frame = Frame.find_by(game_id: game_id, player_id: player_id, number: frame_number)
      @knocked_pins = knocked_pins
      @round = round.to_i
      update_pins!
    rescue => e
      errors.add(:error, e.message)
    end
  end

  private

  def update_pins!
    update_frame!({ knocked_pins_key => knocked_pins, round: round })
  end

  def update_frame!(attrs)
    frame.update(attrs) unless frame.finished?
    check_update
  end

  def check_update
    errors.add(:error, frame.errors.full_messages[0]) unless frame.valid?
    frame.reload
  end

  # @returns [Symbol]
  # it could be :knocked_pins1, :knocked_pins2 or :knocked_pins3
  def knocked_pins_key
    "knocked_pins#{round}".to_sym
  end

  def second_round_regular_frame?
    second_round? && !frame.strike?
  end

  def second_round?
    round == 2
  end

  def special_play?
    knocked_all_pins? && !frame.strike && !frame.spare
  end

  def knocked_all_pins?
    knocked_pins == 10
  end
end

