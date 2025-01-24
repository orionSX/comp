Rails.application.routes.draw do
  root "welcome#index"
  resources :users
  resources :computers
  resources :reservations

  post "reconnect_db", to: "application#reconnect_db"
  post "disconnect_db", to: "application#disconnect_db"

  match "/db_connection_error", to: "error#db_connection_error", via: :get
end
