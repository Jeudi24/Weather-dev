Geocoder.configure(
  timeout: 5,
  lookup: :google,
  units: :mi,
  api_key: Rails.application.credentials.dig(Rails.env.to_sym, :google_geocoder_api_key)
)
