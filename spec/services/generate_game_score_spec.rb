describe GenerateGameScore do
  let(:game) do
    service = StartGame.new
    service.call(names: ['Fernando', 'Diego'])
    service.game
  end
  context 'Simple game' do
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
end
