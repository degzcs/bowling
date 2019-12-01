describe StartGame do

  let(:names) do
    3.times.map { |i| "Alan #{i}" }
  end

  it 'should start a new game' do
    subject.call(names: names)
    expect(subject.errors.messages).to eq({})
    expect(subject.game.players.map(&:name)).to eq(names)
    expect(subject.game.frames.count).to be 30
  end

  it 'raises an error because the names params is missing' do
    expect{ subject.call({}) }.to raise_error ArgumentError
  end
end
