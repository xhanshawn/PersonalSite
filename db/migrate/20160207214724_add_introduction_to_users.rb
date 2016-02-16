class AddIntroductionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduction, :text, :join_table => "users_developers"
  end
end
