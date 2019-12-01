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

  private

  def create_params
    params.permit(names: []).require(:names)
  end
end
