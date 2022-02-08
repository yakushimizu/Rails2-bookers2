class AddStarToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :star, :integer
  end
end
