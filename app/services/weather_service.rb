# Service Object to handle external API calls for weather data
class WeatherService
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5"

  def initialize(lat:, long:)
    @lat = lat
    @long = long
    @api_key = Rails.application.credentials.dig(Rails.env.to_sym, :open_weather_api_key)
  end

  # Fetch the current weather for the provided lat/long
  # @return [Hash] parsed weather data (temperature, high, low, description)
  def fetch_current_weather
    response = self.class.get("/weather", query: { lat: @lat, lon: @long, appid: @api_key, units: "imperial" })
    handle_api_errors(response)
    self.class.parse_weather(response)
  end

  # Fetch the forecast for the provided lat/long
  # @return [Array<Hash>] parsed forecast data (temperature, high, low, description)
  def fetch_forecast
    response = self.class.get("/forecast", query: { lat: @lat, lon: @long, appid: @api_key, units: "imperial" })
    handle_api_errors(response)
    self.class.parse_forecast(response["list"])
  end

  private

  # Error handling for external API failures
  # Raise error in case of failure so that the controller can rescue it and display appropriate messages
  def handle_api_errors(response)
    unless response.success?
      raise "API Error: #{response['message']}"
    end
  end

  # Parse the weather data into a simplified hash
  # @param [Hash] response: the API response data
  # @return [Hash] parsed forecast details
  def self.parse_weather(response)
    {
      temperature: response["main"]["temp"],
      high: response["main"]["temp_max"],
      low: response["main"]["temp_min"],
      description: response["weather"][0]["description"],
      time: Time.at(response["dt"])
    }
  end

  # Parse the forecast data into a simplified hash
  # @param [Hash] response: the API response data
  # @return [Array<Hash>] parsed forecast details
  def self.parse_forecast(response)
    response.map do |forecast|
      self.parse_weather(forecast)
    end
  end
end
