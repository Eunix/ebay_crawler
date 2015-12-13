class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query

      t.timestamps null: false
    end

    add_index :searches, :query
  end
end
