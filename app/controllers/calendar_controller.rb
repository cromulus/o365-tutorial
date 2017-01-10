class CalendarController < ApplicationController

  include AuthHelper

  def index
    oauth_token = get_access_token
    email = session[:user_email]
    if oauth_token
      @user = User.find_by_email(email)
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url
    end
  end

  def feed
    @user = User.find_by_token(params[:token])
    redirect_to root_url unless @user


    events = @user.get_calendar
    cal = Icalendar::Calendar.new
    events.each do |event|
      cal.event do |e|
        e.uid      = event['Id']
        start_time = Time.zone.parse(event['Start']['DateTime'])
        end_time   = Time.zone.parse(event['End']['DateTime'])
        if start_time.seconds_since_midnight == 0
          e.dtstart  = Icalendar::Values::Date.new(start_time)
          e.dtend    = Icalendar::Values::Date.new(end_time)
        else
          e.dtstart  = Icalendar::Values::DateTime.new(start_time)
          e.dtend    = Icalendar::Values::DateTime.new(end_time)
        end
        if event['Location'] && event['Location']['DisplayName']
          e.location = event['Location']['DisplayName']
        end
        e.summary     = event['Subject']
        e.description = event['Subject']
        # e.freebusy do |f|
        #   f.dtstart = Icalendar::Values::DateTime.new(start_time)
        #   f.dtend = Icalendar::Values::DateTime.new(end_time)
        #   f.comment = 'Busy'
        # end if event['ShowAs'] == 'Busy'
      end
    end
    cal.publish
    render text: cal.to_ical
  end


end
