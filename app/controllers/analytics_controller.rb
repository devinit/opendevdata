class AnalyticsController < ApplicationController
  require 'date'
  require 'google/api_client'
  require 'active_support/core_ext'

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
  	#TODO store in DB
  	#weekly comparison
    this_week = weekly((Date.today - 6).strftime('%Y-%m-%d'), Date.today.strftime('%Y-%m-%d'))
    last_week = weekly((Date.today - 13).strftime('%Y-%m-%d'),(Date.today - 7).strftime('%Y-%m-%d'))
    #over view
    overview = overView()
    #year end and year end values
    year_start = Date.today.beginning_of_year
    year_end = Date.today.end_of_year
    this_year = yearly(year_start.strftime('%Y-%m-%d'),year_end.strftime('%Y-%m-%d'))
 		last_year = yearly((Date.civil( year_start.year-1, year_start.month, year_start.day )).strftime('%Y-%m-%d'),
 												(Date.civil(year_end.year-1, year_end.month,year_end.day )).strftime('%Y-%m-%d'))
 		#browser chart
 		countries = pieChart('country')
 		#os chart
 		os = pieChart('operatingSystem')
 		#visitors chart
 		visitors = pieChart('userType')
 		#single value stats
    stats_count = stats()
    #json
    render json: {'thisWeek' => this_week, 'lastWeek' => last_week,'countries'=>countries,'os'=>os,'overview'=>overview,
    							'stats' =>stats_count,'thisYear' => this_year,'lastYear' => last_year,'visitors'=>visitors}
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

  def overView
  	parameters = {
        'ids'=> @id,
        'metrics': 'ga:pageviews',
        'dimensions': 'ga:date',
        'start-date':'30daysAgo',
        'end-date'=> (Date.today).strftime('%Y-%m-%d')
        }
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
    return results.data.rows
  end

  def pieChart(dimensions)
  	parameters = {
        'ids'=> @id,
        'dimensions'=>"ga:#{dimensions}",
        'metrics': 'ga:pageviews',
        'sort': '-ga:pageviews',
        'start-date' => (Date.today).strftime('%Y-%m-%d'),
        'end-date'=> (Date.today -240).strftime('%Y-%m-%d'),
        'max-results': 5
        }
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
    return results.data.rows
  end

  def yearly(start_date,end_date)
  	 parameters = {
        'ids' => @id,
       	'dimensions': 'ga:month,ga:nthMonth',
        'metrics': 'ga:users',
        'start-date' => start_date,
        'end-date' => end_date
    }
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
    return results.data.rows
  end

  def stats
    parameters = {
        'ids' => @id,
        'metrics' => "ga:pageviews,ga:sessions",
        'start-date' => (Date.today - 30).strftime('%Y-%m-%d'),
        'end-date' => Date.today.strftime('%Y-%m-%d')
    }
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
    return results.data.rows
  end

end

