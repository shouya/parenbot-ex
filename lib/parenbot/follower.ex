defmodule Parenbot.Follower do
  use GenServer

  alias Parenbot.Twitter.Client

  @follow_back_delay :timer.minutes(5)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Process.send_after(self(), :follow_back, 1000)
    {:ok, nil}
  end

  @impl true
  def handle_info(:follow_back, _) do
    for follower_uid <- new_followers() do
      follow(follower_uid)
    end

    Process.send_after(self(), :follow_back, @follow_back_delay)
    {:noreply, nil}
  end

  def new_followers do
    followers = get_ids(Client.list_followers(count: 100))
    following = get_ids(Client.list_following(count: 500))

    if is_nil(followers) or is_nil(following) do
      []
    else
      all_followers = MapSet.new(followers)
      already_followed = MapSet.new(following)

      all_followers
      |> MapSet.difference(already_followed)
      |> Enum.to_list()
    end
  end

  def get_ids({:ok, %{"ids" => ids}}), do: ids
  def get_ids(_), do: nil

  defp follow(uid) do
    case Client.follow(uid) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end
end
