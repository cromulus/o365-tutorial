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
    unless @user.calendar_cache.nil?
      events = JSON.parse(@user.calendar_cache)
    else
      token_hash = JSON.parse(@user.oauth_token)
      access_token = get_access_token(token_hash)
      events = @user.get_events(access_token, @user.email)
      @user.calendar_cache = events.to_json
      @user.save
    end
    cal = Icalendar::Calendar.new
    events.each do |event|
      cal.event do |e|
        start_time = Time.zone.parse(event['Start']['DateTime'])
        end_time   = Time.zone.parse(event['End']['DateTime'])
        e.dtstart  = Icalendar::Values::DateTime.new(start_time)
        e.dtend    = Icalendar::Values::DateTime.new(end_time)
        e.summary     = event['Subject']
        e.description = event['Subject']
      end
    end
    cal.publish
    render text: cal.to_ical
  end


end
