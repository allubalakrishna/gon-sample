class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :country
      t.integer :gender

      t.timestamps
    end
  end
end
