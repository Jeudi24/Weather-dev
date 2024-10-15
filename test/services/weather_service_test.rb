require "test_helper"
require "vcr"

class WeatherServiceTest < Minitest::Test
  describe "#fetch_forecast" do
    before do
      lat, long = %w[37.7749 -122.4194]
      @service = WeatherService.new(lat: lat, long: long)
    end

    it "fetches the forecast" do
      VCR.use_cassette("weather_service/fetch_forecast") do
        result = @service.fetch_forecast

        assert result.is_a?(Array), "Result should be an array"
        assert result.first.key?(:temperature), "Temperature should be present in the result"
        assert result.first.key?(:high), "High temperature should be present in the result"
        assert result.first.key?(:low), "Low temperature should be present in the result"
        assert result.first.key?(:description), "Description should be present in the result"
        assert result.first.key?(:time), "Time should be present in the result"
      end
    end

    it "raises an error when the API request fails" do
      @service = WeatherService.new(lat: "invalid", long: "invalid")
      VCR.use_cassette("weather_service/fetch_forecast_error") do
        assert_raises RuntimeError do |e|
          @service.fetch_forecast
          e.message.include?("wrong latitude")
        end
      end
    end
  end

  describe "#fetch_current_weather" do
    before do
      lat, long = %w[37.7749 -122.4194]
      @service = WeatherService.new(lat: lat, long: long)
    end

    it "fetches the current weather" do
      VCR.use_cassette("weather_service/fetch_current_weather") do
        result = @service.fetch_current_weather

        assert result.key?(:temperature), "Temperature should be present in the result"
        assert result.key?(:high), "High temperature should be present in the result"
        assert result.key?(:low), "Low temperature should be present in the result"
        assert result.key?(:description), "Description should be present in the result"
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
