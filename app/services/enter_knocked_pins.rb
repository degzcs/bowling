class EnterKnockedPins < ActiveModelService
  attr_reader :frame

  def initialize
  end

  def call(game_id:, player_id:, frame_number:, knocked_pins:)
     ActiveRecord::Base.transaction do
      @frame ||= Frame.find_by(game_id: game_id, player_id: player_id, number: frame_number)
      all_pins_knocked?(knocked_pins) ? mark_frame!(frame_number) : update_pins!(knocked_pins)
    rescue => e
      errors.add(:error, e.message)
    end
  end

  private

  def all_pins_knocked?(knocked_pins)
    knocked_pins == 10
  end

  def mark_frame!
    frame.first_round? ? strike! : spare!
  end

  def strike!
    if frame.tenth?
      frame.update(strike: true)
    else
      frame.update({ knocked_pins_key => knocked_pins }) unless frame.finished?
    end
  end

  def spare!
    if frame.tenth?
      frame.update(strike: true)
    else
      frame.update({ knocked_pins_key => knocked_pins }) unless frame.finished?
    end
  end

  def update_pins!(knocked_pins)
    frame.update({ knocked_pins_key => knocked_pins }) unless frame.finished?
    check_update
  end

  def check_update
    errors.add(:error, frame.errors.full_messages[0]) unless frame.valid?
    frame.reload
  end

  def knocked_pins_key
    frame.beginning_of_the_frame? ? :knocked_pins1 : :knocked_pins2
  end
end

