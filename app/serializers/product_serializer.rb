class ProductSerializer < ::ApplicationSerializer
  attribute :id,      source: :object
  attribute :name,    source: :object
end