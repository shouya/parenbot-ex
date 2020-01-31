defmodule Parenbot.Twitter.Client do
  @api_base "https://api.twitter.com/1.1"

  @client Tesla.client([Tesla.Middleware.JSON])

  alias Parenbot.OAuth

  @spec request(Tesla.Env.method(), String.t(), Tesla.options()) ::
          Tesla.Env.result() | :no_return
  def request(method, path, opts \\ []) do
    headers = opts[:headers] || []
    query = opts[:query] || []

    url = to_string(Tesla.build_url(Path.join(@api_base, path), query))
    auth_hdrs = OAuth.oauth_headers(method, url, query)

    tesla_opts =
      opts
      |> Keyword.put(:headers, headers ++ [auth_hdrs])
      |> Keyword.put(:method, method)
      |> Keyword.put(:url, url)

    case Tesla.request(@client, tesla_opts) do
      {:ok, %{status: code, body: body}} when code in 200..299 ->
        {:ok, body}

      {:ok, %{status: 429}} ->
        OAuth.rotate()
        request(method, path, opts)

      {:ok, e} ->
        {:error, e}

      {:error, e} ->
        {:error, e}
    end
  end

  def home_timeline(query \\ []) do
    query = Keyword.merge([tweet_mode: :extended], query)
    request(:get, "/statuses/home_timeline.json", query: query)
  end

  def post_update(status, opts \\ []) do
    query = [{:status, status} | opts]
    request(:post, "/statuses/update.json", query: query)
  end

  def get_user() do
    request(:get, "/account/verify_credentials.json")
  end
end
