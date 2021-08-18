class SwaggersController < ActionController::API

  # json configuration swagger api
  # Use https://petstore.swagger.io/
  # example for developer Explore: 'http://localhost:3000/swaggers/api'
  # GET swaggers/api
  def api
    render json: Swagger::Builder::Api.new.attributes
  end
end