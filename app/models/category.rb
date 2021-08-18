class Category < ApplicationRecord
  has_one :parent, class_name: 'Category', foreign_key: :id, primary_key: :parent_id
  has_many :children, ->{ includes(:children) }, class_name: 'Category', foreign_key: :parent_id

  validates_presence_of :name
  # TODO add validation for parents loop

  def products_first_page
    Product.order_by_name.where(category_id: family_ids).paginate(page: 1)
  end

  def family_ids
    children.inject([id]) { |ids, child| ids + [child.id] + child.family_ids }.uniq
  end
end