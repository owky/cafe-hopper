require 'net/http'
require 'json'

class OpenAi
  def initialize(api_key, condition)
    @api_key = api_key
    @conversation = [ { role: "system", content: condition } ]
  end

  def chat_completion(message)
    uri = ::URI.parse('https://api.openai.com/v1/chat/completions')
    params = {
      model: 'gpt-3.5-turbo',
      messages: @conversation << { role: "user", content: message }
    }
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@api_key}"
    }

    http = ::Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.post(uri.path, params.to_json, headers)

    completion = JSON.parse(res.body)["choices"].first["message"]
    @conversation << completion

    completion["content"]
  end
end
