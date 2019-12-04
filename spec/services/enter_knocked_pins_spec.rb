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
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 5, round: 1)
        expect(subject.errors.count).to eq 0
        expect(subject.frame.reload.knocked_pins1).to eq 5
        expect(subject.frame.knocked_pins2).to eq 0
        expect(subject.frame.round).to eq 1
      end

      it 'should not save because exceeds the number allowed of pins' do
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 12, round: 1)
        expect(subject.errors.full_messages[0]).to eq 'Error Knocked pins1 must be less than or equal to 10'
        expect(subject.frame.reload.knocked_pins1).to eq 0
        expect(subject.frame.reload.knocked_pins2).to eq 0
      end

      it 'raises an error for missing args' do
        expect { subject.call() }.to raise_error ArgumentError
      end

      context 'Strike' do
        it 'should save the strike and the knocked pins' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 10, round: 1)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 10
          expect(subject.frame.strike).to eq true
          expect(subject.frame.spare).to eq false
          expect(subject.frame.knocked_pins2).to eq 0
        end
      end
    end

    context 'Second Ball' do
      let(:frame) do
        Frame.find_by(game_id: game.id, player_id: player1.id, number: 1)
      end

      before :each do
        frame.update(knocked_pins1: 2, round: 1)
      end

      it 'should save the knocked pins by ball' do
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 5, round: 2)
        expect(subject.errors.count).to eq 0
        expect(subject.frame.knocked_pins1).to eq 2
        expect(subject.frame.knocked_pins2).to eq 5
      end

      it 'should not save because exceeds the number allowed of pins' do
        subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 12, round: 2)
        expect(subject.errors.full_messages[0]).to eq 'Error Knocked pins2 must be less than or equal to 10'
        expect(subject.frame.reload.knocked_pins1).to eq 2
        expect(subject.frame.knocked_pins2).to eq 0
      end

      context 'Spare' do
        it 'should save the spare and the knocked pins' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 1, knocked_pins: 8, round: 2)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 2
          expect(subject.frame.knocked_pins2).to eq 8
          expect(subject.frame.strike).to eq false
          expect(subject.frame.spare).to eq true
        end
      end
    end
  end

  context 'Tenth Frame' do
    context 'Strike' do
      let(:frame) do
        Frame.find_by(game_id: game.id, player_id: player1.id, number: 10)
      end

      context 'First Ball' do
        it 'should save the strike' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 10, round: 1)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 10
          expect(subject.frame.knocked_pins2).to eq 0
          expect(subject.frame.knocked_pins3).to eq 0
          expect(subject.frame.strike).to eq true
          expect(subject.frame.spare).to eq false
        end
      end
      context 'Second Ball' do
        before :each do
          frame.update(round: 1, strike: true, knocked_pins1: 10)
        end

        it 'should save the knocked_pins' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 7, round: 2)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 10
          expect(subject.frame.knocked_pins2).to eq 7
          expect(subject.frame.knocked_pins3).to eq 0
          expect(subject.frame.strike).to eq true
          expect(subject.frame.spare).to eq false
        end

        it 'should save the knocked_pins when is another strike' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 10, round: 2)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 10
          expect(subject.frame.knocked_pins2).to eq 10
          expect(subject.frame.knocked_pins3).to eq 0
          expect(subject.frame.strike).to eq true
          expect(subject.frame.spare).to eq false
        end
      end
      context 'Third Ball' do
        before :each do
          frame.update(round: 2, knocked_pins1: 10, knocked_pins2: 5, strike: true)
        end

        it 'should save the knocked_pins' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 3, round: 3)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 10
          expect(subject.frame.knocked_pins2).to eq 5
          expect(subject.frame.knocked_pins3).to eq 3
          expect(subject.frame.strike).to eq true
          expect(subject.frame.spare).to eq false
        end

        it 'should save the knocked_pins when is another strike' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 10, round: 3)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 10
          expect(subject.frame.knocked_pins2).to eq 5
          expect(subject.frame.knocked_pins3).to eq 10
          expect(subject.frame.strike).to eq true
          expect(subject.frame.spare).to eq false
        end
      end
    end
    context 'Spare' do
      let(:frame) do
        Frame.find_by(game_id: game.id, player_id: player1.id, number: 10)
      end

      context 'First Ball' do
        it 'should save the regular knocked pins' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 2, round: 1)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 2
          expect(subject.frame.knocked_pins2).to eq 0
          expect(subject.frame.knocked_pins3).to eq 0
          expect(subject.frame.strike).to eq false
          expect(subject.frame.spare).to eq false
        end
      end

      context 'Second Ball' do
        before :each do
          frame.update(round: 1, knocked_pins1: 2)
        end

        it 'should save the spare' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 8, round: 2)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 2
          expect(subject.frame.knocked_pins2).to eq 8
          expect(subject.frame.knocked_pins3).to eq 0
          expect(subject.frame.strike).to eq false
          expect(subject.frame.spare).to eq true
        end
      end
      context 'Third Ball' do
        before :each do
          frame.update(round: 2, knocked_pins1: 2, knocked_pins2: 8, spare: true)
        end

        it 'should save the last roud knocked pins' do
          subject.call(game_id: game.id, player_id: player1.id, frame_number: 10, knocked_pins: 5, round: 3)
          expect(subject.errors.count).to eq 0
          expect(subject.frame.reload.knocked_pins1).to eq 2
          expect(subject.frame.knocked_pins2).to eq 8
          expect(subject.frame.knocked_pins3).to eq 5
          expect(subject.frame.strike).to eq false
          expect(subject.frame.spare).to eq true
        end
      end
    end
  end
end

