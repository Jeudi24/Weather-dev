# Weather Forecast App

This Ruby on Rails app accepts an address as input and provides weather forecast details based on the address.

## Features:
- Accepts a user-provided address, converts it to lat/long coordinates using Geocoder.
- Fetches weather data (temperature, high/low, description) from OpenWeatherMap API.
- Caches the results for 30 minutes to improve performance.

## Setup:
1. Clone the repository.
2. Install dependencies by running `bundle install`
3. Obtain the master.key and put it in `config/master.key` or run the following:

  Prerequisites: Obtain API Keys from
    - Google Cloud Console for Google Geocoding API
    - OpenWeatherMap API

  ```
    rm -rf config/credentials.yml.enc
    EDITOR=nano rails credentials:edit
  ```

  paste the following after the defaults:

  ```
  development:
    google_geocoder_api_key: <Replace me with API Key>
    open_weather_api_key: <Replace me with API Key>

  production:
    google_geocoder_api_key: <Replace me with API Key>
    open_weather_api_key: <Replace me with API Key>

  test:
    google_geocoder_api_key: test
    open_weather_api_key: test
  ```

  4. run `rails s` to start the development environment.

  ## Demo
  The Weather App is hosted here:
  https://weather-app-delian.fly.dev/