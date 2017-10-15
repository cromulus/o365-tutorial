Rails.application.routes.draw do

  get 'calendar/index'
  get 'calendar/feed/:token', to: 'calendar#feed', as: 'calendar_feed'


  get 'authorize' => 'auth#gettoken'
  get 'refresh/:token', to: 'auth#refresh', as: :refresh_path
  get '/check.txt', to: proc { [200, {}, ['simple_check']] }
  root "auth#home"
end
