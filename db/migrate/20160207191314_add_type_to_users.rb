class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    :join_table => "courses_students"
  end
end
