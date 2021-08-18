class CategorySerializer < ::ApplicationSerializer
  attribute :id,         source: :object
  attribute :name,       source: :object
  attribute :products,   source: :object, field: :products_first_page, with: ProductSerializer
  attribute :children,   source: :object, with: CategorySerializer
end