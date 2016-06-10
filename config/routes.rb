Rails.application.routes.draw do
  get 'contacts/index'

  get 'calendar/index'
  get 'calendar/feed/:token', to: 'calendar#feed'

  get 'mail/index'

  root 'application#home'
  get 'authorize' => 'auth#gettoken'
end
