class AddContactInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_info, :text
  end
end
