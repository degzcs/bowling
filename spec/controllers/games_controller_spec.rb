describe GamesController, type: :request do
  context 'POST - Start a new game' do
    let(:names) do
      3.times.map { |i| "Alan #{i}" }
    end
    it 'should initialize a game' do
      expected_game = {
        total_score: 0,
        players: [
          {
            id: 1,
            name: 'Alan 0'
          },
          {
            id: 2,
            name: 'Alan 1'
          },
          {
            id: 3,
            name: 'Alan 2'
          }
        ]
      }
      post games_path, params: { names: names }
      expect(JSON.parse response.body).to eq expected_game.as_json
    end
  end

  context 'POST - Enter Knocked Pins' do
    let(:game) do
      service = StartGame.new
      service.call(names: ['Fernando', 'Diego'])
      service.game
    end
    let(:player1) { game.players.first }

    it 'should input the number of pins by ball' do
      expected_game = {
        id: 1,
        knocked_pins1: 3,
        knocked_pins2: 0
      }
      post game_score_path(game.id), params: { player_id: player1.id, frame_number: 1, knocked_pins: 3, round: 1 }
      expect(JSON.parse response.body).to eq expected_game.as_json
    end
  end
end
