# Service Object to handle external API calls for weather data
class WeatherService < ApiService
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
      city_name: response["name"],
      temperature: response["main"]["temp"].round,
      date: Time.at(response["dt"]).to_date,
      high: response["main"]["temp_max"].round,
      low: response["main"]["temp_min"].round,
      feels_like: response["main"]["feels_like"].round,
      condition: response["weather"][0]["description"].titleize,
      icon: get_feather_icon_from_weather_description(response["weather"][0]["description"]),
      time: Time.at(response["dt"])
    }
  end

  # Parse the forecast data into a simplified hash
  # @param [Hash] response: the API response data
  # @return [Array<Hash>] parsed forecast details
  # Map the weather description to a Feather icon name
  # @param [String] description: the weather description
  # @return [String] the Feather icon name
  def self.get_feather_icon_from_weather_description(description)
    case description
    when "clear sky"
      "sun"
    when "few clouds"
      "cloud"
    when "scattered clouds"
      "cloud"
    when "broken clouds"
      "cloud"
    when "shower rain"
      "cloud-rain"
    when "rain"
      "cloud-rain"
    when "thunderstorm"
      "cloud-lightning"
    when "snow"
      "cloud-snow"
    when "mist"
      "cloud-drizzle"
    else
      "sun"
    end
  end
end
