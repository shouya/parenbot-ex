defmodule Parenbot.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Parenbot.Replier
      # Parenbot.Follower
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
