Geocoder.configure(
  timeout: 5,
  lookup: :google,
  units: :mi,
  api_key: Rails.application.credentials.google_geocoding_api_key,
)
