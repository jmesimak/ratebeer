class RemoveStyleFromBeer < ActiveRecord::Migration
  def up
    remove_column :beers, :style
  end

  def down
    add_column :beers, :style, :string
  end
end
