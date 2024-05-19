require 'net/http'
require 'json'

class OpenAi
  GPT35TURBO = 'gpt-3.5-turbo'
  GPT4O = 'gpt-4o'

  def initialize(api_key, model, debug_mode = false)
    @api_key = api_key
    @model = model
    @debug_mode = debug_mode
  end

  def system(system_message)
    @conversation = [ { role: "system", content: system_message } ]
  end

  def chat_completion(message)
    uri = ::URI.parse('https://api.openai.com/v1/chat/completions')
    params = {
      model: @model,
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

    log completion if @debug_mode

    completion["content"]
  end

  private
  def log completion
    puts completion
    puts
  end
end
