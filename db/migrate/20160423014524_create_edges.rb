class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.references :tag, index: true
      t.string :edge_type
      t.integer :target_id

      t.timestamps null: false
    end
    add_foreign_key :edges, :tags
  end
end
