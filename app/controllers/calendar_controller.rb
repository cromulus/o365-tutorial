class CalendarController < ApplicationController

  include AuthHelper

  def index
    oauth_token = get_access_token
    email = session[:user_email]
    if oauth_token
      @user = User.find_by_email(email)
      #@oauth_token = oauth_token
      #@email = email
      #@events = get_events(@oauth_token, @email)
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url
    end
  end

  def feed
    @user = User.find_by_token(params[:token])
    redirect_to root_url unless @user
    token_hash = JSON.parse(@user.oauth_token)
    access_token = get_access_token(token_hash)
    @events = get_events(access_token, @user.email)
    cal = Icalendar::Calendar.new
    @events.each do |event|
      cal.event do |e|
        start_time = Time.zone.parse(event['Start']['DateTime'])
        end_time = Time.zone.parse(event['End']['DateTime'])
        e.dtstart = Icalendar::Values::DateTime.new(start_time)
        e.dtend   = Icalendar::Values::DateTime.new(end_time)
        e.summary     = event['Subject']
        e.description = event['Subject']
      end
    end
    cal.publish
    render text: cal.to_ical
  end

  # will fail because auth tokens are short lived. need a refresh token
  def get_events(oauth_token,email)
    @events = []
    # If a token is present in the session, get messages from the inbox
    conn = Faraday.new(url: 'https://outlook.office.com') do |faraday|
      # Outputs to the console
      # faraday.response :logger
      # Uses the default Net::HTTP adapter
      faraday.adapter  Faraday.default_adapter
    end
    # url = '/api/v2.0/Me/calendargroups'
    # url = '/api/v2.0/Me/Events?$orderby=Start/DateTime asc&$select=Subject,Start,End&$top=10'
    start = (Time.current - 5.days).strftime('%FT%R')
    end_time = (Time.current + 30.days).strftime('%FT%R')
    url = "/api/v2.0/me/calendarview?startDateTime=#{start}&endDateTime=#{end_time}&$top=50"
    while !url.nil?
      response = conn.get do |request|
        # Get events from the calendar
        # Sort by Start in ascending orderby
        # Get the first 50 results
        request.url url
        request.headers['Prefer'] = 'outlook.timezone="Eastern Standard Time"'
        request.headers['Authorization'] = "Bearer #{oauth_token}"
        request.headers['Accept'] = 'application/json'
        request.headers['X-AnchorMailbox'] = email
      end
      res  = JSON.parse(response.body)
      url = res["@odata.nextLink"] # is nil if there is no more to fetch
      @events += res['value']
    end
  end

end
