class RemovePostFromTags < ActiveRecord::Migration
  def change
    remove_reference :tags, :post, index: true
    # remove_foreign_key :tags, :posts   # comment this because report error for no foreign key when do migratation

  end
end
