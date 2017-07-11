Rails.application.routes.draw do
  get 'contacts/index'

  get 'calendar/index'
  get 'calendar/feed/:token', to: 'calendar#feed', as: 'calendar_feed'

  get 'mail/index'

  root 'application#home'
  get 'authorize' => 'auth#gettoken'
  get 'refresh/:token', to: 'auth#refresh', as: :refresh_path
  get '/check.txt', to: proc { [200, {}, ['simple_check']] }
end
