Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/game' => 'game#start_new_game'
  get '/score' => 'game#display_score'
end
