defmodule JsonTransform do
  @moduledoc """
  JsonTransform is a module for transforming the keys of a Map or Struct before
  conversion to JSON.
  """

  @type map_or_list :: map() | list()
  @type string_or_atom :: String.t | atom(  )
  @type trans_fn :: (number -> String.t)

  @doc """
  Recursively transforms keys of maps. The root data structure can be a Map or a
  List.

  Keys are passed to a user-provided transformation function that accepts a
  string and returns a transformed string.

  Atom map keys are converted to strings before being passed to the transform
  function.

  See JsonTransform.Transformers for a list of included transformation
  functions. You are also free to provide your own.
  """
  @spec transform(value :: map_or_list, trans_fn :: trans_fn) :: map_or_list
  def transform(value, trans_fn)
  def transform(%_{} = value, trans_fn) do
    value |> Map.from_struct |> transform(trans_fn)
  end
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

  @spec transform_key(key :: string_or_atom, trans_fn :: trans_fn) :: String.t
  defp transform_key(key, trans_fn) when is_binary(key), do: trans_fn.(key)
  defp transform_key(key, trans_fn) when is_atom(key) do
     key |> Atom.to_string |> trans_fn.()
   end
  defp transform_key(key, _), do: key

  @spec transform_value(value :: any, trans_fn :: trans_fn) :: any
  defp transform_value(value, trans_fn) when is_map(value) or is_list(value) do
    value |> transform(trans_fn)
  end
  defp transform_value(value, _), do: value
end
