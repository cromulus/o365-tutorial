# Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
class AuthController < ApplicationController
  include AuthHelper
  # this is an access token. We should replace it with a refresh token
  def gettoken
    token = get_token_from_code params[:code]
    Rails.logger.info token
    session[:azure_token] = token.to_hash
    email = get_user_email token.token
    session[:user_email] = email
    Rails.logger.info email
    @user = User.find_or_create_by(email: email)
    @user.oauth_token = token.to_hash.to_json
    @user.refresh_token = token.refresh_token
    @user.token_active = true
    @user.save
    Rails.logger.info 'saved!'
    redirect_to calendar_index_url
  end

  def refresh
    @user = User.find_by(token: params[:token])
    redirect_to root_url unless @user
    @user.notified = false
    @user.notified_at = nil
    @user.save
    redirect_to get_login_url
  end

  def home
    Rails.logger.info 'showing login link'
    login_url = get_login_url
    render html: "<a href='#{login_url}'>Log in</a>".html_safe
  end
end

# MIT License:

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# ""Software""), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
