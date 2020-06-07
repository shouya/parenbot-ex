defmodule Parenbot.MixProject do
  use Mix.Project

  def project do
    [
      app: :parenbot,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Parenbot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oauther, "~> 1.1"},
      {:tesla, "~> 1.3"},
      {:hackney, "~> 1.10"},
      {:jason, ">= 1.0.0"},
      {:sentry, "~> 7.0"}
    ]
  end
end
