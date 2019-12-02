describe EnterKnockedPins do
  let(:game) do
    service = StartGame.new
    service.call(names: ['Fernando', 'Diego'])
    service.game
  end
  let(:player1) { game.players.first }

  context 'First Frame' do
    context 'First Ball' do
      it 'should save the knocked pins by ball' do
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 5)
        expect(subject.errors.count).to eq 0
        expect(subject.frame.knocked_pins1).to eq 5
        expect(subject.frame.knocked_pins2).to eq 0
      end

      it 'should not save because exceeds the number allowed of pins' do
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 12)
        expect(subject.errors.full_messages[0]).to eq 'Error Knocked pins1 must be less than 10'
        expect(subject.frame.reload.knocked_pins1).to eq 0
        expect(subject.frame.reload.knocked_pins2).to eq 0
      end

      it 'raises an error for missing args' do
        expect { subject.call() }.to raise_error ArgumentError
      end
    end
    context 'Second Ball' do
      let(:frame) do
        Frame.find_by(game_id: game.id, player_id: player1.id, number: 1)
      end

      it 'should save the knocked pins by ball' do
        frame.update(knocked_pins1: 2)
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 5)
        expect(subject.errors.count).to eq 0
        expect(subject.frame.knocked_pins1).to eq 2
        expect(subject.frame.knocked_pins2).to eq 5
      end

      it 'should not save because exceeds the number allowed of pins' do
        frame.update(knocked_pins1: 7)
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 12)
        expect(subject.errors.full_messages[0]).to eq 'Error Knocked pins2 must be less than 10'
        expect(subject.frame.reload.knocked_pins1).to eq 7
        expect(subject.frame.knocked_pins2).to eq 0
      end
    end
  end
end

