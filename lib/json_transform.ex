defmodule JsonTransform do

  def snake(value), do: value |> transform(&to_snake/1)
  def camel(value), do: value |> transform(&to_camel/1)

  def transform(value, trans_fn)
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

  def transform_key(key, trans_fn) when is_binary(key), do: trans_fn.(key)
  def transform_key(key, trans_fn) when is_atom(key), do: key |> Atom.to_string |> trans_fn.()
  def transform_key(key, _), do: key

  def transform_value(value, trans_fn) when is_map(value) or is_list(value) do
    value |> transform(trans_fn)
  end
  def transform_value(value, _), do: value

  def to_snake(key) when is_binary(key) do
    key |> Inflex.underscore()
  end
  def to_snake(key), do: key

  def to_camel(key) when is_binary(key) do
    key |> Inflex.camelize(:lower)
  end
  def to_camel(key), do: key
end
