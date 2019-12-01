describe GamesController, type: :request do
  let(:names) do
    3.times.map { |i| "Alan #{i}" }
  end

  context 'POST - Start a new game' do
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
end
