class AddHomepageContentToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :homepage_content, :text
  end
end
