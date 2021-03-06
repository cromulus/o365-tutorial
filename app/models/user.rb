# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  oauth_token   :string
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  refresh_token :string
#

class User < ApplicationRecord
  has_secure_token
  include AuthHelper

  def update_calendar
    begin
      token_hash = JSON.parse(oauth_token)
      access_token = get_access_token(token_hash, self)
      events = get_events(access_token, email)
      self.calendar_cache = events.to_json
    rescue OAuth2::Error => e
      if e.code == 'invalid_grant'
        self.token_active = false
        UserNotifierMailer.invalid_token(self).deliver if self.notified_at.nil?
        save
      end
      false
    end
    true
  end

  def background_calendar_update
    if (updated_at - Time.now) > 5.minutes.to_i
      UserCalendarUpdateJob.perform_later(id)
    end
  end

  def get_events(oauth_token, email)
    events = []
    # If a token is present in the session, get messages from the inbox
    conn = Faraday.new(url: 'https://outlook.office.com') do |faraday|
      # Outputs to the console
      # faraday.response :logger
      # Uses the default Net::HTTP adapter
      faraday.adapter Faraday.default_adapter
    end
    # url = '/api/v2.0/Me/calendargroups'
    # url = '/api/v2.0/Me/Events?$orderby=Start/DateTime asc&$select=Subject,Start,End&$top=10'
    start    = (Time.current - 180.days).strftime('%FT%R')
    end_time = (Time.current + 365.days).strftime('%FT%R')
    url = "/api/v2.0/me/calendarview?startDateTime=#{start}&endDateTime=#{end_time}&$top=50"
    until url.nil?
      response = conn.get do |request|
        # Get events from the calendar
        # Sort by Start in ascending orderby
        # Get the first 50 results
        request.url url
        request.options[:timeout] = 30
        request.options[:open_timeout] = 30
        request.headers['Prefer'] = "outlook.timezone=\"#{ENV['TZ']}\""
        request.headers['Authorization'] = "Bearer #{oauth_token}"
        request.headers['Accept'] = 'application/json'
        request.headers['X-AnchorMailbox'] = email
      end
      res = JSON.parse(response.body)
      url = res['@odata.nextLink'] # is nil if there is no more to fetch
      events += res['value']
    end
    events
  end

  def get_calendar
    if calendar_cache.nil?
      token_hash = JSON.parse(oauth_token)
      access_token = get_access_token(token_hash)
      events = get_events(access_token, email)
      self.calendar_cache = events.to_json
      save
    else
      events = JSON.parse(calendar_cache)
    end
    events
  end
end
