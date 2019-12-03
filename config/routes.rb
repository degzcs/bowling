Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :games, only: [:create] do
    post :knocked_pins, to: 'games#enter_knocked_pins'
    get :score, to: 'games#score'
  end
end
