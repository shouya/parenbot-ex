import Config

config :extwitter, :oauth,
  consumer_key: System.get_env("CONSUMER_KEY"),
  consumer_secret: System.get_env("CONSUMER_SECRET"),
  access_token: System.get_env("ACCESS_TOKEN"),
  access_token_secret: System.get_env("ACCESS_TOKEN_SECRET")
