Rails.application.routes.draw do
  resources :appointments, :sessions
  
  # You can have the root of your site routed with "root"
  root 'appointments#welcome'
  #get 'login', to: 'sessions#login', as: :login
  #login_url 'appointments#login'
end
