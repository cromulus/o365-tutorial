class UserCalendarUpdateJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.update_calendar
    user.save
  end
end
