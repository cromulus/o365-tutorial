class UserCalendarUpdateJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    if user.token_active
      user.update_calendar
      user.save
      Rails.logger.info("Calendar Update for #{user_id}")
    else
      Rails.logger.info("Calendar Update: token expired for #{user_id}")
    end
    true
  end
end
