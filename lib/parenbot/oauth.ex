defmodule Parenbot.OAuth do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    "OAUTH_CREDENTIALS"
    |> System.get_env("")
    |> parse_credentials()
    |> case do
      {:ok, creds} -> {:ok, creds}
      {:error, e} -> {:stop, e}
    end
  end

  def oauth_headers(method, url, query) do
    query = Enum.map(query, fn {k, v} -> {to_string(k), v} end)
    creds = current_credential()
    params = OAuther.sign(to_string(method), url, query, current_credential)
    {auth_hdrs, _query} = OAuther.header(params)
    auth_hdrs
  end

  def rotate() do
    GenServer.call(__MODULE__, :rotate)
  end

  defp current_credential() do
    GenServer.call(__MODULE__, :current_credential)
  end

  @impl true
  def handle_call(:current_credential, _, [cred | xs]), do: cred

  @impl true
  def handle_call(:rotate, _, [cred | xs]), do: xs ++ [cred]

  defp parse_credentials(creds) do
    creds
    |> String.split(";")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn
      [a, b, c, d] ->
        OAuther.credentials(
          consumer_key: a,
          consumer_secret: b,
          token: c,
          token_secret: d
        )

      _ ->
        :invalid
    end)
    |> Enum.filter(&(&1 != :invalid))
    |> case do
      [] -> {:error, "no valid oauth credentials found"}
      creds -> {:ok, creds}
    end
  end
end
