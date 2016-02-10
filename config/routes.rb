Rails.application.routes.draw do
  resources :appointments, :sessions, :twilio
  
  # You can have the root of your site routed with "root"
  root 'appointments#welcome'
  
  post 'twilio/process_sms' => 'twilio#process_sms'
  post 'twilio/voice' => 'twilio#voice'
  post 'twilio/call' => 'twilio#call'
  #get 'login', to: 'sessions#login', as: :login
  #login_url 'appointments#login'
end
