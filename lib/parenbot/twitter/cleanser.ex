defmodule Parenbot.Twitter.Cleanser do
  # skip retweets
  def cleanse_tweet(%{"retweeted_status" => %{}}), do: nil

  def cleanse_tweet(%{
        "id" => id,
        "full_text" => text,
        "retweeted" => false,
        "user" => %{"screen_name" => user}
      }) do
    %{id: id, text: text, user: user}
  end

  def cleanse_tweet(_), do: nil
end
