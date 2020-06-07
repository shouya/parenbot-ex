import Config

config :tesla, :adapter, Tesla.Adapter.Hackney

config :logger,
  backends: [:console, Sentry.LoggerBackend]

config :sentry,
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  included_environments: [:prod]
