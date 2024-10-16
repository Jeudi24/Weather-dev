if Rails.env.test?
  VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock
    config.filter_sensitive_data("<API_KEY>") { Rails.application.credentials.dig(Rails.env.to_sym, :open_weather_api_key) }
  end
end
