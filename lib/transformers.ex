defmodule JsonTransform.Transformers do
  def to_snake(key) when is_binary(key) do
    key |> Inflex.underscore()
  end
  def to_snake(key), do: key

  def to_camel(key) when is_binary(key) do
    key |> Inflex.camelize(:lower)
  end
  def to_camel(key), do: key
end
