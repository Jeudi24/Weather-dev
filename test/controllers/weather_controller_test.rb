require "test_helper"
require "address_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers # Explicitly include route helpers

  test "should get index" do
    get weather_index_url
    assert_response :success
  end

  test "should get index with address" do
    VCR.use_cassette("weather_controller/index/success") do
      get weather_index_url, params: { address: AddressHelper::WHITE_HOUSE_ADDRESS }
      assert_response :success
    end
  end

  test "error message when address not found" do
    VCR.use_cassette("weather_controller/index/fetch_error") do
      get weather_index_url, params: { address: "1234 Not a Real Address" }
      assert_response :success
      assert_select ".flash-message"
    end
  end
end
