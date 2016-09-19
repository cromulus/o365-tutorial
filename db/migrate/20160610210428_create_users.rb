class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.index :email, unique: true
      t.string :oauth_token
      t.string :token
      t.index :token, unique: true
      t.timestamps null: false
    end
  end
end
