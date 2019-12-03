class EnterKnockedPins < ActiveModelService
  attr_reader :frame, :knocked_pins, :round

  def initialize
  end

  def call(game_id:, player_id:, frame_number:, knocked_pins:, round:)
     ActiveRecord::Base.transaction do
      @frame = Frame.find_by(game_id: game_id, player_id: player_id, number: frame_number)
      @knocked_pins = knocked_pins
      @round = round
      special_play? ? mark_frame! : update_pins!
    rescue => e
      errors.add(:error, e.message)
    end
  end

  private

  def special_play?
    knocked_pins == 10 && !frame.strike && !frame.spare
  end

  def mark_frame!
    new_attrs = first_round? ? strike_attrs! : spare_attrs!
    update_frame!(new_attrs.merge(round: round).compact)
  end

  def strike_attrs!
    {
      knocked_pins_key => (knocked_pins unless frame.tenth?),
      strike: true
    }
  end

  def spare_attrs!
    {
      knocked_pins_key => (knocked_pins unless frame.tenth?),
      spare: true
    }
  end

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

  def knocked_pins_key
    select_knocked_pins1? ? :knocked_pins1 : :knocked_pins2
  end

  def select_knocked_pins1?
    (frame.tenth? && frame.strike?) ? second_round? : first_round?
  end

  def first_round?
    round ==  1
  end

  def second_round?
    round ==  2
  end
end

