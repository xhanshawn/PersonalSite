class AddEdupageContentToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :edupage_content, :text
  end
end
