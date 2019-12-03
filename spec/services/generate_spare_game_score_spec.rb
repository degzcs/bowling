describe GenerateGameScore do
  let(:game) do
    service = StartGame.new
    service.call(names: ['Fernando', 'Diego'])
    service.game
  end
  context 'Spare game' do
    before :each do
      game.frames.where.not(number: [2,3]).update_all(knocked_pins1: 2, knocked_pins2: 3, round: 2)
      game.frames.where(number: [2,3]).update(spare: true, knocked_pins1: 9, knocked_pins2: 1, round: 2)
    end

    it 'should sum the scores for each frame' do
      expected_score = {
        players: [
          {
            name: 'Fernando',
            total_score: 71,
            frames: [
              {
                number: 1,
                score: 5
              },
              {
                number: 2,
                score: 24
              },
              {
                number: 3,
                score: 36
              },
              {
                number: 4,
                score: 41
              },
              {
                number: 5,
                score: 46
              },
              {
                number: 6,
                score: 51
              },
              {
                number: 7,
                score: 56
              },
              {
                number: 8,
                score: 61
              },
              {
                number: 9,
                score: 66
              },
              {
                number: 10,
                score: 71
              }
            ]
          },
          {
            name: 'Diego',
            total_score: 71,
            frames: [
              {
                number: 1,
                score: 5
              },
              {
                number: 2,
                score: 24
              },
              {
                number: 3,
                score: 36
              },
              {
                number: 4,
                score: 41
              },
              {
                number: 5,
                score: 46
              },
              {
                number: 6,
                score: 51
              },
              {
                number: 7,
                score: 56
              },
              {
                number: 8,
                score: 61
              },
              {
                number: 9,
                score: 66
              },
              {
                number: 10,
                score: 71
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
