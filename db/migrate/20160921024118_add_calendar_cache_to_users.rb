class AddCalendarCacheToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :calendar_cache, :text
  end
end
