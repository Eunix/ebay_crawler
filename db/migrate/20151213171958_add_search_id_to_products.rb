class AddSearchIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :search_id, :integer
    add_index :products, :search_id
  end
end
