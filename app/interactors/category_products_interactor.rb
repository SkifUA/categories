class CategoryProductsInteractor < ApplicationInteractor
  delegate :params,   to: :context

  def call
    context.products = Product.where(category_id: family_ids)
                              .order_by_name(order)
                              .paginate(page: page)
  end

  def validation
    add_error!(:params_required)       if params.blank? || !params.is_a?(Hash)
    add_error!(:category_id_required)  if params[:id].blank?
    add_error!(:category_missing)      if category.blank?
  end

  private

  def family_ids
    category.family_ids
  end

  def category
    @category ||= Category.find_by(id: params[:id])
  end

  def order
    params[:name_order].to_s == 'desc' ? :desc : :asc
  end

  def page
    params[:page].presence || 1
  end
end
