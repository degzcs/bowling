class GenerateGameScore
  attr_reader :game, :score
  def initialize
  end

  def call(game_id:)
    @game = Game.find(game_id)

    @score = { players: [] }
    game.players.each do |player|
      player_data = {}
      player_data[:name] = player.name
      player_data[:frames] = []
      player.frames.inject(0) do |cumulative, frame|
        frame_data = {}
        frame_data[:number] = frame.number
        frame_data[:score] = cumulative + calculate_score_from(frame)
        #frame_data[:strike] = 'X' if frame.strike?
        #frame_data[:spare] = '/' if frame.spare?

        player_data[:frames] << frame_data
        frame_data[:score]
      end
      player_data[:total_score] = player_data[:frames].last[:score]
      @score[:players] << player_data
    end
  end

  def calculate_score_from(frame)
    if frame.strike?
     calculate_strike_for(frame)
    elsif frame.spare?
     calculate_spare_for(frame)
    else
      frame.knocked_pins
    end
  end

  def calculate_strike_for(frame, cumulative = 0)
    next_frame = next_frame_for(frame)
    if next_frame.strike?
      calculate_strike_for(next_frame, cumulative) + next_frame.knocked_pins
    else
      frame.knocked_pins + next_frame.knocked_pins
    end
  end

  def next_frame_for(frame)
    Frame.where(game_id: frame.game_id, number: frame.number + 1).first
  end

  def calculate_spare_for(frame)
    frame.knocked_pins + next_frame_for(frame).knocked_pins1
  end
end
