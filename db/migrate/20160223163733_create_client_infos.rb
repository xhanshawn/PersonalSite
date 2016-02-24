class CreateClientInfos < ActiveRecord::Migration
  def change
    create_table :client_infos do |t|
      t.references :user, index: true
      t.string :ip
      t.datetime :date

      t.timestamps null: false
    end
    add_foreign_key :client_infos, :users
  end
end
