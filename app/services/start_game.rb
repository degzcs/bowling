class StartGame < ActiveModelService
  attr_reader :game

  def initialize
  end

  def call(names:)
    ActiveRecord::Base.transaction do
      @game = Game.create
      players = create_players_from(names)
      players.each do |player|
        Frame::PER_GAME.times do |i|
          Frame.create(player: player, game: game, number: i)
        end
      end
    rescue => e
      errors.add(:error, e.message)
    end
  end

  private

  def create_players_from(names)
    names.map{ |name| Player.create(name: name) }
  end
end

