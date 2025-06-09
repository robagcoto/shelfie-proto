RubyLLM.configure do |config|
  # config.openai_api_key = ENV["OPENAI_API_KEY"]
  # config.openai_api_base = "https://models.inference.ai.azure.com"
  config.openrouter_api_key = ENV['OPENROUTER_API_KEY']
end
