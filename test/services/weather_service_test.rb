require "test_helper"
require "vcr"
require "address_helper"

class WeatherServiceTest < Minitest::Test
  describe "#fetch_five_day_forecast" do
    before do
      lat, long = AddressHelper::WHITE_HOUSE_COORDINATES
      @service = WeatherService.new(lat: lat, long: long)
    end

    it "fetches the five day forecast" do
      VCR.use_cassette("weather_service/fetch_forecast") do
        result = @service.fetch_five_day_forecast

        assert result.is_a?(Array), "Result should be an array"
        assert_equal 5, result.size, "Result should contain 5 days of forecast data"

        assert result.first.key?(:date), "Date should be present in the result"
        assert result.first.key?(:temperature), "Temperature should be present in the result"
        assert result.first.key?(:icon), "Icon should be present in the result"
      end
    end

    it "raises an error when the API request fails" do
      @service = WeatherService.new(lat: "invalid", long: "invalid")
      VCR.use_cassette("weather_service/fetch_forecast_error") do
        assert_raises RuntimeError do |e|
          @service.fetch_five_day_forecast
          e.message.include?("wrong latitude")
        end
      end
    end
  end

  describe "#fetch_current_weather" do
    before do
      lat, long = AddressHelper::WHITE_HOUSE_COORDINATES
      @service = WeatherService.new(lat: lat, long: long)
    end

    it "fetches the current weather" do
      VCR.use_cassette("weather_service/fetch_current_weather") do
        result = @service.fetch_current_weather

        assert result.is_a?(Hash), "Result should be a hash"

        assert result.key?(:city_name), "City name should be present in the result"
        assert result.key?(:temperature), "Temperature should be present in the result"
        assert result.key?(:date), "Date should be present in the result"
        assert result.key?(:high), "High temperature should be present in the result"
        assert result.key?(:low), "Low temperature should be present in the result"
        assert result.key?(:feels_like), "Feels like temperature should be present in the result"
        assert result.key?(:condition), "Condition should be present in the result"
        assert result.key?(:icon), "Icon should be present in the result"
        assert result.key?(:time), "Time should be present in the result"
      end
    end

    it "raises an error when the API request fails" do
      @service = WeatherService.new(lat: "invalid", long: "invalid")
      VCR.use_cassette("weather_service/fetch_current_weather_error") do
        assert_raises RuntimeError do
          @service.fetch_current_weather
        end
      end
    end
  end
end
