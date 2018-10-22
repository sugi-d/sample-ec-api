class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.references :user, null: false
      t.references :transaction
      t.integer :amount, null: false
      t.integer :kind, null: false, limit: 1

      t.timestamps
    end
  end
end
