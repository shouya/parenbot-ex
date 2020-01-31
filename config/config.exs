import Config

config :parenbot, :oauth,
  consumer_key: System.get_env("CONSUMER_KEY", ""),
  consumer_secret: System.get_env("CONSUMER_SECRET", ""),
  token: System.get_env("ACCESS_TOKEN", ""),
  token_secret: System.get_env("ACCESS_TOKEN_SECRET", "")

config :tesla, :adapter, Tesla.Adapter.Hackney
