class EnterKnockedPins < ActiveModelService
  attr_reader :frame

  def initialize
  end

  def call(game_id:, player_id:, frame_number:, knocked_pins:)
     ActiveRecord::Base.transaction do
      @frame = Frame.find_by(game_id: game_id, player_id: player_id, number: frame_number)
      update_pins!(knocked_pins)
    rescue => e
      errors.add(:error, e.message)
    end
  end

  private

  def update_pins!(knocked_pins)
    frame.update({ round_key => knocked_pins }) unless frame.finished?
    check_update
  end

  def check_update
    errors.add(:error, frame.errors.full_messages[0]) unless frame.valid?
    frame.reload
  end

  def round_key
    frame.first_round? ? :knocked_pins1 : :knocked_pins2
  end
end

