require 'rails_helper'

describe GamesController , type: :request do
  let(:players) { create_list :player, 3 }

  context 'POST - Create Game' do
    it 'should initialize a game' do
      post game_index_path, params: players
      expect(response.body).to be ''
    end
  end
end
