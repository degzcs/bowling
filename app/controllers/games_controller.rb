class GamesController < ActionController::API
  def create
    service = StartGame.new
    service.call(names: create_params)

    if service.valid?
      render json: service, serializer: StartGameSerializer
    else
      render json: { error: service.errors.full_messages[0] }
    end
  end

  def score
    service = EnterKnockedPins.new
    new_params = enter_knocked_params.merge(game_id: params[:game_id]).to_h.symbolize_keys
    service.call(new_params)

    if service.valid?
      render json: service.frame, serializer: FrameSerializer
    else
      render json: { error: service.errors.full_messages[0] }
    end
  end

  private

  def create_params
    params.permit(names: []).require(:names)
  end

  def enter_knocked_params
    params.permit(:player_id, :frame_number, :knocked_pins, :round)
  end
end
