class RemoveColumnsFromDevelopers < ActiveRecord::Migration
  def change
  	remove_column :developers, :introduction
  	remove_column :developers, :education
  	remove_column :developers, :homepage_content
  	remove_column :developers, :edupage_content
  end
end
