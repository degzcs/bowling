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
        frame_data[:score] = cumulative + frame.knocked_pins

        player_data[:frames] << frame_data
        frame_data[:score]
      end
      player_data[:total_score] = player_data[:frames].last[:score]
      @score[:players] << player_data
    end
  end
end
