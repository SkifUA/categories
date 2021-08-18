Rails.application.routes.draw do
  root to: 'page#index'

  get '/categories',              to: 'categories#index'
  get '/categories/:id/products', to: 'categories#products'

  # swagger
  get 'swagger',                 to: 'swaggers#api'
end
