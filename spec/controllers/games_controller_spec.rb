describe GamesController, type: :request do
  let(:names) do
    3.times.map { |i| "Alan #{i}" }
  end

  context 'POST - Create Game' do
    it 'should initialize a game' do
      post games_path, params: { names: names }
      expect(response.body).to eq "Let's play guys!!"
    end
  end
end
