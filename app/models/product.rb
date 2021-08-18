class Product < ApplicationRecord
  belongs_to :category

  validates_presence_of :name

  scope :by_category,  ->(category_id) { where(category_id: category_id) }
  scope :order_by_name, ->(order=:asc) { order(name: order.to_sym == :desc ? :desc : :asc ) }
end