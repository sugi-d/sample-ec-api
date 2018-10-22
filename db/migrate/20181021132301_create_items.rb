class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.unsigned_integer :price, null: false
      t.integer :publish_status, limit: 1, null: false, default: 0
      t.integer :status, limit: 1, null: false, default: 1

      t.timestamps
    end
  end
end
