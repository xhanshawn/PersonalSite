class AddColumnsToPageContents < ActiveRecord::Migration
  def change
  	add_column :page_contents, :html_content, :text
  	add_column :page_contents, :page_name, :string
  end
end
