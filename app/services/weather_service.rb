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
  def fetch_five_day_forecast
    response = self.class.get("/forecast", query: { lat: @lat, lon: @long, appid: @api_key, units: "imperial" })
    handle_api_errors(response)
    self.class.parse_forecast(response["list"])
  end

  private

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
  def self.parse_forecast(api_response)
    grouped_by_date = api_response.group_by { |record| record["dt_txt"].to_date }

    grouped_by_date.map do |forecast_date, daily_records|
      most_frequent_condition = most_frequent(daily_records.map { |record| record["weather"].first["description"] })
      {
        date: forecast_date,
        temperature: daily_records.map { |record| record["main"]["temp"].round }.max,
        icon: get_feather_icon_from_weather_description(most_frequent_condition)
      }
    end
  end

  # Find the most frequently occurring element in an array
  # @param [Array] array: the array to search
  # @return [Object] the most frequently occurring element
  def self.most_frequent(array)
    array.group_by(&:itself).max_by { |_, occurrences| occurrences.size }.first
  end

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
