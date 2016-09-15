class AddPubhlishColumnToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :pubhlish, :boolean
  end
end