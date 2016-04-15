class RemovePostFromTags < ActiveRecord::Migration
  def change
    remove_reference :tags, :post, index: true
    # remove_foreign_key :tags, :posts
  end
end
