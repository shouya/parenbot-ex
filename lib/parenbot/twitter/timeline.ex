defmodule Parenbot.Twitter.Timeline do
  use GenServer

  def start_link(processor, opts) do
    GenServer.start_link(__MODULE__, {processor, opts})
  end

  @impl true
  def init({processor, opts}) do
    send(self(), :loop)

    state = %{
      processor: processor,
      opts: opts,
      last_fetch: DateTime.utc_now()
    }

    {:ok, state}
  end

  @impl true
  def handle_info(
        :loop,
        %{
          processor: processor,
          opts: opts,
          last_fetch: last_fetch
        } = state
      ) do
    opts = Keyword.merge(opts, since: last_fetch, tweet_mode: :extended)

    case ExTwitter.home_timeline(opts) do
      xs ->
        Enum.each(xs, &process_tweet(&1, processor))
    end

    # send(self(), :loop)
    {:noreply, state}
  end

  defp process_tweet(%{retweeted_status: rt, raw_data: t}, processor)
       when is_nil(rt) do
    IO.inspect(t)

    tweet = %{
      user: t.user.screen_name,
      text: t.full_text
    }

    send(processor, {:tweet, tweet})
  end

  defp process_tweet(_t, _processor) do
  end
end
