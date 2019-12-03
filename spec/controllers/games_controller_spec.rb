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
      post game_knocked_pins_path(game.id), params: { player_id: player1.id, frame_number: 1, knocked_pins: 3, round: 1 }
      expect(JSON.parse response.body).to eq expected_game.as_json
    end
  end

  context 'GET - Score' do
    let(:game) do
      service = StartGame.new
      service.call(names: ['Fernando'])
      service.game
    end
    let(:player1) { game.players.first }
    before :each do
      game
      Frame.where(number: 1).update(knocked_pins1: 10, round: 1, strike: true)
      Frame.where(number: 2).update(knocked_pins1: 9, knocked_pins2: 1, round: 2, spare: true)
      Frame.where(number: 3).update(knocked_pins1: 5, knocked_pins2: 5, round: 2, spare: true)
      Frame.where(number: 4).update(knocked_pins1: 7, knocked_pins2: 2, round: 2)
      Frame.where(number: 5).update(knocked_pins1: 10, round: 1, strike: true)
      Frame.where(number: 6).update(knocked_pins1: 10, round: 1, strike: true)
      Frame.where(number: 7).update(knocked_pins1: 10, round: 1, strike: true)
      Frame.where(number: 8).update(knocked_pins1: 9, knocked_pins2: 0, round: 2)
      Frame.where(number: 9).update(knocked_pins1: 8, knocked_pins2: 2, round: 2, spare: true)
      Frame.where(number: 10).update(knocked_pins1: 5, knocked_pins2: 4, round: 2, strike: true)
    end

    it 'should input the number of pins by ball' do
      expected_score = {
        players: [
          {
            name: 'Fernando',
            total_score: 172,
            frames: [
              {
                number: 1,
                score: 20
              },
              {
                number: 2,
                score: 35
              },
              {
                number: 3,
                score: 52
              },
              {
                number: 4,
                score: 61
              },
              {
                number: 5,
                score: 91
              },
              {
                number: 6,
                score: 120
              },
              {
                number: 7,
                score: 139
              },
              {
                number: 8,
                score: 148
              },
              {
                number: 9,
                score: 163
              },
              {
                number: 10,
                score: 172
              }
            ]
          }
        ]
      }
      get game_score_path(game.id)
      expect(JSON.parse response.body).to eq expected_score.as_json
    end
  end
end
