require 'clockwork'
require_relative "../config/boot"
require_relative "../config/environment"

module Clockwork
  handler do |job,time|
    puts "Running #{job} at #{time}"
  end

  every(60.minutes, 'calendars.update_calendar') do
    UpdateCalendarsJob.perform_later
  end
end
