class AddRefLinkToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :ref_link, :string
  end
end
