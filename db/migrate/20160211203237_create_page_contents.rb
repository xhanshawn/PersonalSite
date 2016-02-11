class CreatePageContents < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.references :developer, index: true

      t.timestamps null: false
    end
    add_foreign_key :page_contents, :developers
  end
end
