class GoogleAnalytics
  include Sidekiq::Worker
  require 'date'
	require 'google/api_client'

	def initializer
		@client  = Google::APIClient.new(:application_name => ENV['GA_APP_NAME'], :application_version => '1.0')
    key_file = File.join('config', ENV['GA_KEY_FILE_NAME'])
    key      = Google::APIClient::PKCS12.load_key(key_file, 'notasecret')
    service_account = Google::APIClient::JWTAsserter.new(
        ENV['GA_SERVICE_ACCOUNT_EMAIL'], key)
    @client.authorization = service_account.authorize
    @analytics = @client.discovered_api('analytics', 'v3')
	end

  def perform
		parameters = {
	        'ids'         => "ga:" + ENV['GA_VIEW_ID'],
	        'start-date'  => (Date.today - 30).strftime("%Y-%m-%d"),
	        'end-date'    => Date.today.strftime("%Y-%m-%d"),
	        'metrics'     => "ga:pageviews",
	      }
	  results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => parameters)
		if results.error?
      puts results.error_message
      return {}
    else
      hash = {}
      # some internal googles object magic :)
			puts results
      results.data.rows.each do |r|
        hash["#{r[0]}-#{r[1]}-#{r[2]}"] = r[3].to_i
      end
		return hash
  end
end
