class UpdateCalendarsJob < ApplicationJob
  queue_as :default

  def perform
    User.all.find_each { |u| UserCalendarUpdateJob.perform_later(u.id) }
  end
end
