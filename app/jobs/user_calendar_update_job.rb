class UserCalendarUpdateJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.update_calendar
    user.save
    Rails.logger.info("Calendar Update for #{user_id}")
  end
end
