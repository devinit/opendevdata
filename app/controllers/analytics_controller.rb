class AnalyticsController < ApplicationController
  require 'date'
  require 'google/api_client'

  before_filter :authentication, :only => ['data']

  def index
  end

  def authentication
    @client = Google::APIClient.new(:application_name => ENV['GA_APP_NAME'], :application_version => '1.0')
    key_file = File.join('config', ENV['GA_KEY_FILE_NAME'])
    key = Google::APIClient::PKCS12.load_key(key_file, 'notasecret')
    service_account = Google::APIClient::JWTAsserter.new(
        ENV['GA_SERVICE_ACCOUNT_EMAIL'],
        ['https://www.googleapis.com/auth/analytics.readonly', 'https://www.googleapis.com/auth/prediction'],
        key)
    @client.authorization = service_account.authorize
    @analytics = @client.discovered_api('analytics', 'v3')
    @id = "ga:#{ENV['GA_VIEW_ID']}"
  end

  def data
    this_week = weekly((Date.today - 6).strftime('%Y-%m-%d'), Date.today.strftime('%Y-%m-%d'))
    last_week = weekly((Date.today - 13).strftime('%Y-%m-%d'),(Date.today - 7).strftime('%Y-%m-%d'))
    views = stats('pageviews')
    render json: {'thisWeek' => this_week, 'lastWeek' => last_week, 'views' => views}
  end

  private
  def weekly(start_date, end_date)
    parameters = {
        'ids' => @id,
        'dimensions' => 'ga:date,ga:nthDay',
        'metrics' => 'ga:sessions',
        'start-date' => start_date,
        'end-date' => end_date
    }
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
    return results.data.rows
  end

  def stats(metrics)
    parameters = {
        'ids' => @id,
        'metrics' => "ga:#{metrics}",
        'start-date' => (Date.today - 30).strftime('%Y-%m-%d'),
        'end-date' => Date.today.strftime('%Y-%m-%d')
    }
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
    return results.data.rows
  end

end

