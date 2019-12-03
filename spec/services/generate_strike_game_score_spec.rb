describe GenerateGameScore do
  let(:game) do
    service = StartGame.new
    service.call(names: ['Fernando', 'Diego'])
    service.game
  end
  context 'Strike game' do
    before :each do
      game.frames.where.not(number: [2,3,4,5]).update_all(knocked_pins1: 2, knocked_pins2: 3, round: 2)
      game.frames.where(number: [2,3,4,5]).update(strike: true, knocked_pins1: 10, round: 1)
    end

    it 'should sum the scores for each frame' do
      expected_score = {
        players: [
          {
            name: 'Fernando',
            total_score: 140,
            frames: [
              {
                number: 1,
                score: 5
              },
              {
                number: 2,
                score: 45
              },
              {
                number: 3,
                score: 75
              },
              {
                number: 4,
                score: 100
              },
              {
                number: 5,
                score: 115
              },
              {
                number: 6,
                score: 120
              },
              {
                number: 7,
                score: 125
              },
              {
                number: 8,
                score: 130
              },
              {
                number: 9,
                score: 135
              },
              {
                number: 10,
                score: 140
              }
            ]
          },
          {
            name: 'Diego',
            total_score: 140,
            frames: [
              {
                number: 1,
                score: 5
              },
              {
                number: 2,
                score: 45
              },
              {
                number: 3,
                score: 75
              },
              {
                number: 4,
                score: 100
              },
              {
                number: 5,
                score: 115
              },
              {
                number: 6,
                score: 120
              },
              {
                number: 7,
                score: 125
              },
              {
                number: 8,
                score: 130
              },
              {
                number: 9,
                score: 135
              },
              {
                number: 10,
                score: 140
              }
            ]
          },
        ]
      }
      subject.call(game_id: game.id)
      expect(subject.score).to include expected_score
    end
  end
end
