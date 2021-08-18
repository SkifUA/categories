def run_seed(categories, parent_name)
  brands = ['Reebok', 'Adidas', 'Nike']
  parent = Category.create(name: parent_name)

  categories.each do |key, value|
    category = Category.create(name: key, parent_id: parent.id)
    puts category
    value.each do |name|
      cat = Category.create(name: "#{category.name} #{name}", parent_id: category.id)
      brands.each do |product|
        Product.create(name: "#{product} #{cat.name}", category_id: cat.id)
      end
    end
  end
end

if Category.first.nil?
  shoes = {
    'Summer' => ['Sneakers', 'Sandals', 'Slippers'],
    'Winter' => ['Sneakers', 'Boots', 'Moccasins'],
    'Demi-season' => ['Sneakers', 'Boots', 'Moccasins']
  }

  clothes = {
    'Summer' => ['T-shirt', 'Shorts', 'Shirt'],
    'Winter' => ['Jacket', 'Raincoat', 'Coat'],
    'Demi-season' => ['Jacket', 'Raincoat', 'Coat']
  }

  run_seed(shoes, 'Shoes')
  run_seed(clothes, 'Clothes')
else
  puts 'Database is not empty'
end

