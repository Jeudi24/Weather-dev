require "httparty"

class ApiService
  include HTTParty

  private

  # Error handling for external API failures
  # Raise error in case of failure so that the controller can rescue it and display appropriate messages
  def handle_api_errors(response)
    unless response.success?
      raise "API Error: #{response['message']}"
    end
  end
end
