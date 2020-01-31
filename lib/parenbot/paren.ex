defmodule Parenbot.Paren do
  @chars [
           "()[]{}（）［］｛｝⦅⦆〚〛⦃⦄“”‘’‹›«»",
           "「」〈〉《》【】〔〕⦗⦘『』〖〗〘〙｢｣",
           "⟦⟧⟨⟩⟪⟫⟮⟯⟬⟭⌈⌉⌊⌋⦇⦈⦉⦊❛❜❝❞❨❩❪❫❴❵❬❭❮❯❰❱❲❳",
           "⏜⏝⎴⎵⏞⏟⏠⏡﹁﹂﹃﹄︹︺︻︼︗︘︿﹀︽︾﹇﹈︷︸"
         ]
         |> :erlang.iolist_to_binary()
         |> String.graphemes()

  @open Enum.take_every(@chars, 2)
  @closed Enum.drop_every(@chars, 2)
  @map Map.new(Enum.zip(@open, @closed))

  @spec detect(binary) :: :matched | {:unmatched, binary()} | :invalid
  def detect(binary) do
    binary
    |> String.graphemes()
    |> Enum.reject(fn x -> x not in @open and x not in @closed end)
    |> detect([])
  end

  defp detect(chars, stack)

  defp detect([], []), do: :matched
  defp detect([], filo), do: {:unmatched, to_right_parens(filo)}
  defp detect([l | xs], filo) when l in @open, do: detect(xs, [l | filo])
  defp detect([_r | _xs], []), do: :invalid

  defp detect([r | xs], [l | filo]) do
    case Map.get(@map, l) do
      ^r -> detect(xs, filo)
      _ -> :invalid
    end
  end

  defp to_right_parens(ls) do
    :erlang.iolist_to_binary(Enum.map(ls, &@map[&1]))
  end
end
