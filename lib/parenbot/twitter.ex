defmodule Parenbot.Twitter do
  use GenServer

  alias Parenbot.Twitter.Timeline

  @api_options [
    exclude_replies: false
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, nil, {:continue, :verify_authentication}}
  end

  @impl true
  def handle_continue(:verify_authentication, _) do
    if !Application.get_env(:extwitter, :oauth)[:access_token_secret],
      do: command_line_oauth()

    # stream = ExTwitter.stream_user(receive_messages: true)
    # stream = ExTwitter.stream_filter(track: "@parenbot", receive_messages: true)
    {:ok, timeline} = Timeline.start_link(self(), @api_options)
    {:noreply, %{streamer: timeline}}
  end

  @impl true
  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end

  defp command_line_oauth do
    token = ExTwitter.request_token()
    {:ok, auth_url} = ExTwitter.authenticate_url(token.oauth_token)
    IO.puts("Please login and authorize via the URL below:")
    IO.puts(auth_url)
    code = IO.gets(:stdio, "Enter your PIN> ")
    {:ok, access} = ExTwitter.access_token(code, token.oauth_token)

    IO.puts("""
    export ACCESS_TOKEN=#{access.oauth_token}
    export ACCESS_TOKEN_SECRET=#{access.oauth_token_secret}
    """)
  end
end
