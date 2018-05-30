require 'icalendar/tzinfo'
class CalendarController < ApplicationController
  include AuthHelper

  def index
    oauth_token = get_access_token
    email = session[:user_email]
    if oauth_token
      @user = User.find_by(email: email)
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url
    end
  end

  def feed
    @user = User.find_by(token: params[:token])
    redirect_to root_url unless @user

    events = @user.get_calendar

    cal = Icalendar::Calendar.new

    tzid = ENV['TZ']
    tz = TZInfo::Timezone.get tzid
    timezone = tz.ical_timezone Time.zone.now
    cal.add_timezone timezone
    cal.x_wr_timezone = tzid

    events.each do |event|
      cal.event do |e|
        e.uid = event['Id']
        e.x_wr_timezone = tzid
        start_time = DateTime.parse(event['Start']['DateTime'])
        end_time   = DateTime.parse(event['End']['DateTime'])

        if start_time.seconds_since_midnight == 0.0 # all day event
          e.dtstart  = Icalendar::Values::Date.new(start_time, 'tzid' => tzid)
          e.dtend    = Icalendar::Values::Date.new(end_time, 'tzid' => tzid)
        else
          e.dtstart  = Icalendar::Values::DateTime.new(start_time, 'tzid' => tzid)
          e.dtend    = Icalendar::Values::DateTime.new(end_time, 'tzid' => tzid)
        end
        if event['Location'].present? && event['Location']['DisplayName'].present?
          display_name = event['Location']['DisplayName']
          address = event['Location']['Address'].values.join(" ") rescue ''
          e.location = display_name + address
        end
        e.summary     = event['Subject']
        body_content  = event.dig('Body', 'Content')
        e.description = ActionView::Base.full_sanitizer.sanitize(body_content) if body_content.present?

        if event.dig('Location', 'Coordinates').present?
          e.lattitude = event['Location']['Coordinates']['Lattitude']
          e.longitude = event['Location']['Coordinates']['Longitude']
        end

        if event['Organizer'].present?
          e.organizer = event.dig('Organizer','Address')
        end
        # e.freebusy do |f|
        #   f.dtstart = Icalendar::Values::DateTime.new(start_time)
        #   f.dtend = Icalendar::Values::DateTime.new(end_time)
        #   f.comment = 'Busy'
        # end if event['ShowAs'] == 'Busy'
      end
    end
    cal.publish

    @user.background_calendar_update # update as often as the user wants it.
    render text: cal.to_ical
  end
end
