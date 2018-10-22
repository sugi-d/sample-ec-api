class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :user_id, null: false, limit: 8
      t.references :item, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
