class WeatherController < ApplicationController
  def index
    if params[:address].present?
      lat, long = get_location(params[:address])

      cache_key = "weather_#{lat}_#{long}"
      @cache_key_exists = Rails.cache.exist?(cache_key)

      weather_service = WeatherService.new(lat: lat, long: long)

      @current_weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
        weather_service.fetch_current_weather
      end

      @forecast = Rails.cache.fetch("#{cache_key}_forecast", expires_in: 30.minutes) do
        weather_service.fetch_five_day_forecast
      end
    end
  rescue StandardError => e
    flash.now[:alert] = e.message
  end

  private

  def get_location(address)
    response = Geocoder.coordinates(address)
    raise "Could not find location for address" if response.nil?
    response
  end
end
