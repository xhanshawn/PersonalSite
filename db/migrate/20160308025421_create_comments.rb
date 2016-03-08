class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post, index: true
      t.references :user, index: true
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :comments, :posts
    add_foreign_key :comments, :users
  end
end
