class GamesController < ActionController::API
  def create
    service = StarGame.new
    service.call(create_params)

    if service.valid?
      render json: "Let's play guys!!"
    else
      render json: { error: service.error }
    end
  end

  private

  def create_params
    params.require(:names).permit(:names)
  end
end
