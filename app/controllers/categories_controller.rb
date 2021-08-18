class CategoriesController < ApplicationController

  # GET categories/
  def index
    # TODO add paginate
    @categories = Category.all
    render json: { data: CategorySerializer.wrap(@categories), success: true}, status: :ok
  end

  # GET categories/:id/products
  def products
    result = CategoryProductsInteractor.call(params: products_params.to_h)
    if result.success?
      render json: { data: ProductSerializer.wrap(result.products), success: true}, status: :ok
    else
      render json: { error: result.errors, success: false }, status: :unprocessable_entity
    end
  end

  private

  def set_category
    @category = Categories.find(params[:id])
  end

  def products_params
    params.permit( :name_order, :page, :id)
  end
end