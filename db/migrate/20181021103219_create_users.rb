class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :login_token, null: false
      t.integer :status, null: false, limit: 1, default: 0

      t.timestamps
      t.index :email, unique: true
      t.index :login_token, unique: true
    end
  end
end
