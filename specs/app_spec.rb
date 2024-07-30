require_relative 'spec_helper'
require_relative '../app'

describe 'POST /translate' do
  def app
    Sinatra::Application
  end

  let(:stubbed_request) do
      stub_request(:post, 'https://api-free.deepl.com/v2/translate')
        .to_return(status: 200, body: '{"translations":[{"text":"translated_text"}]}')
    end

  context 'valid input params' do
    it 'returns a JSON response with the translation' do
      stubbed_request
      post '/translate', text: 'text', to: 'EN'
      expect(last_response.body).to eq({'translation' => 'translated_text'}.to_json)
    end
  end
  context 'invalid input params' do
    it 'returns a 400 status code' do
      stubbed_request
      post '/translate', text: 'hello'
      expect(last_response.status).to eq(400)
    end
    it 'returns no translation for wrong language' do    
      stub_request(:post, 'https://api-free.deepl.com/v2/translate')
        .to_return(status: 200, body: '{"translations":[{"text":"null"}]}')

      post '/translate', text: 'text', to: 'ENL'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({'translation' => 'null'}.to_json)
    end
  end

end