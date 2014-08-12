defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
      a === b                   -> :equal
      a |> contains_sequence? b -> :superlist
      b |> contains_sequence? a -> :sublist
      true                      -> :unequal
    end
  end

  defp contains_sequence?(_, []), do: true
  defp contains_sequence?([], _), do: false
  defp contains_sequence?(subject = [head | tail], object) do
    if head === hd(object) and Enum.take(subject, Enum.count(object)) === object do
      true
    else
      contains_sequence?(tail, object)
    end
  end
end
