describe GenerateGameScore do
  context 'Simple game' do
    let(:game) do
      service = StartGame.new
      service.call(names: ['Fernando', 'Diego'])
      service.game
    end
    before :each do
      game.frames.update_all(knocked_pins1: 2, knocked_pins2: 3, round: 2)
    end

    it 'should sum the scores for each frame' do
      expected_score = {
        players: [
          {
            name: 'Fernando',
            total_score: 50,
            frames: [
              {
                number: 1,
                score: 5
              },
              {
                number: 2,
                score: 10
              },
              {
                number: 3,
                score: 15
              },
              {
                number: 4,
                score: 20
              },
              {
                number: 5,
                score: 25
              },
              {
                number: 6,
                score: 30
              },
              {
                number: 7,
                score: 35
              },
              {
                number: 8,
                score: 40
              },
              {
                number: 9,
                score: 45
              },
              {
                number: 10,
                score: 50
              }
            ]
          },
          {
            name: 'Diego',
            total_score: 50,
            frames: [
              {
                number: 1,
                score: 5
              },
              {
                number: 2,
                score: 10
              },
              {
                number: 3,
                score: 15
              },
              {
                number: 4,
                score: 20
              },
              {
                number: 5,
                score: 25
              },
              {
                number: 6,
                score: 30
              },
              {
                number: 7,
                score: 35
              },
              {
                number: 8,
                score: 40
              },
              {
                number: 9,
                score: 45
              },
              {
                number: 10,
                score: 50
              }
            ]
          },
        ]
      }
      subject.call(game_id: game.id)
      expect(subject.score).to include expected_score
    end
  end
  context 'Complex game' do
    let(:game) { Game.create }
    let(:player){ Player.create name: 'Fernando' }

    before :each do
      Frame.create(game_id: game.id, player_id: player.id, number: 1, knocked_pins1: 10, round: 1, strike: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 2, knocked_pins1: 9, knocked_pins2: 1, round: 2, spare: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 3, knocked_pins1: 5, knocked_pins2: 5, round: 2, spare: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 4, knocked_pins1: 7, knocked_pins2: 2, round: 2)
      Frame.create(game_id: game.id, player_id: player.id, number: 5, knocked_pins1: 10, round: 1, strike: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 6, knocked_pins1: 10, round: 1, strike: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 7, knocked_pins1: 10, round: 1, strike: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 8, knocked_pins1: 9, knocked_pins2: 0, round: 2)
      Frame.create(game_id: game.id, player_id: player.id, number: 9, knocked_pins1: 8, knocked_pins2: 2, round: 2, spare: true)
      Frame.create(game_id: game.id, player_id: player.id, number: 10, knocked_pins1: 9, knocked_pins2: 1, knocked_pins3: 10, round: 3, strike: true)
    end

    it 'should sum the scores for each frame' do
      expected_score = {
        players: [
          {
            name: 'Fernando',
            total_score: 187,
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
                score: 167
              },
              {
                number: 10,
                score: 187
              }
            ]
          }
        ]
      }
      subject.call(game_id: game.id)
      expect(subject.score).to include expected_score
    end
  end
end
