class StartGameSerializer < ActiveModel::Serializer
  attribute :total_score
  attribute :players

  def total_score
    object.game.total_score
  end

  def players
    object.game.players.select(:id, :name)
  end
end
