class AddIntroductionToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :introduction, :text
  end
end
