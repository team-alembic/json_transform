defmodule JsonTransform do
  @moduledoc """
  JsonTransform is a module for transforming the keys of a Map or Struct before
  conversion to JSON.
  """

  @type map_or_list :: map() | list()
  @type trans_fn :: (String.t -> String.t)

  @doc """
  Transforms the keys of Elixir list or map or struct for the purpose of converting
  the case convention of keys. *trans_fn/1* is the function that takes a string key
  as input and returns a new transformed key.

    See JsonTransform.Transformers for a list of included transformation functions.
  You are also free to provide your own.
  """
  @spec transform(map_or_list, trans_fn) :: map_or_list
  def transform(map_or_list, trans_fn)
  def transform(%_{} = value, trans_fn), do: value |> Map.from_struct |> transform(trans_fn)
  def transform(value, trans_fn) when is_map(value) do
    value
    |> Enum.reduce(%{}, fn ({key, value}, acc) ->
      acc |> Map.put(key |> transform_key(trans_fn), value |> transform_value(trans_fn))
    end)
  end
  def transform(value, trans_fn) when is_list(value) do
    value
    |> Enum.map(fn item ->
      item |> transform_value(trans_fn)
    end)
  end
  def transform(value, _), do: value

  defp transform_key(key, trans_fn) when is_binary(key), do: trans_fn.(key)
  defp transform_key(key, trans_fn) when is_atom(key), do: key |> Atom.to_string |> trans_fn.()
  defp transform_key(key, _), do: key

  defp transform_value(value, trans_fn) when is_map(value) or is_list(value) do
    value |> transform(trans_fn)
  end
  defp transform_value(value, _), do: value
end
