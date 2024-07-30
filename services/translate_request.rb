# frozen_string_literal: true

require 'httparty'
require 'json'

#This class is responsible for making requests to the DeepL API for text translation.
#
# It uses the HTTParty gem to make HTTP requests and the JSON gem to parse the response.
#
# The class has a single public method `#call` which makes a POST request to the DeepL API
# with the provided text and target language.
class TranslateRequestService
  include HTTParty
  base_uri 'https://api-free.deepl.com/v2/'
  #  debug_output $stdout

    # @param text [String, Array<String>] The text to be translated.
    # @param target_lang [String] The target language for translation.
    # @return [void]
    def initialize(text, target_lang)
      @options = {
        body: { text: Array(text), target_lang: }.to_json,
        headers: {
          Authorization: "DeepL-Auth-Key #{ENV['DEEPL_API_KEY']}",
          'Content-Type' => 'application/json'
        },
        timeout: 10
      }
    end
  
  # @return [HTTParty::Response] The response from the DeepL API.
  def call
    translate
  end

  private

  # Sends a POST request to the '/translate' endpoint with the provided options.
  #
  # @return [HTTParty::Response] The response from the API.
  def translate
    self.class.post('/translate', @options)
  end
end
