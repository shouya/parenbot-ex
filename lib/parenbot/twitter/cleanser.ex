defmodule Parenbot.Twitter.Cleanser do
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
