class Emailnotificationforupdate < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :token_active, :boolean, default: true
    add_column :users, :inactive_notification, :boolean, default: false
    add_column :users, :notified_at, :datetime, null: true, default: nil
  end
end
