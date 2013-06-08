class AddDeltaToMovies < ActiveRecord::Migration
  def change
    add_column(:movies, :delta, :boolean, :default => true, :null => false)
  end
end
