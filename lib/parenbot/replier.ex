defmodule Parenbot.Replier do
  use GenServer

  alias Parenbot.Twitter
  alias Parenbot.Paren

  @fetch_delay :timer.seconds(5) + 100
  @face "○(￣□￣○)"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Process.send_after(self(), :process, @fetch_delay)
    {:ok, nil, {:continue, :get_since_id}}
  end

  @impl true
  def handle_continue(:get_since_id, _) do
    case Twitter.Client.home_timeline(count: 1) do
      [tweet] -> {:noreply, %{since_id: max_id([tweet])}}
      _ -> {:stop, :failed_to_update, nil}
    end
  end

  @impl true
  def handle_info(:process, %{since_id: since_id} = state) do
    case Twitter.Client.home_timeline(since_id: since_id, count: 200) do
      {:ok, []} ->
        Process.send_after(self(), :process, @fetch_delay)
        {:noreply, state}

      {:ok, tweets} ->
        tweets
        |> Enum.map(&Twitter.Cleanser.cleanse_tweet/1)
        |> Enum.reject(&is_nil/1)
        |> Enum.map(fn tweet -> {Paren.detect(tweet[:text]), tweet} end)
        |> Enum.each(fn
          {:matched, _} -> :ok
          {:invalid, _} -> :ok
          {{:unmatched, completed}, tweet} -> reply_with(tweet, completed)
        end)

        Process.send_after(self(), :process, @fetch_delay)
        {:noreply, %{state | since_id: max_id(tweets)}}

      {:error, e} ->
        {:stop, e, state}
    end
  end

  defp max_id([]), do: nil

  defp max_id(tweets) do
    Enum.max(Enum.map(tweets, fn %{"id" => id} -> id end))
  end

  defp reply_with(%{user: user, id: id}, parens) do
    tweet = "@#{user} #{parens}#{@face}"
    Twitter.Client.post_update(tweet, in_reply_to_status_id: id)
  end
end
