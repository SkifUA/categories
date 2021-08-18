class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :parent_id
      t.timestamps
    end

    create_table :products do |t|
      t.string :name, null: false
      t.belongs_to :category
    end
  end
end
