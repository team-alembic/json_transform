# JsonTransform

JsonTransform is a module for transforming the keys of a Map or Struct before
conversion to JSON.

      JsonTransform.transform(%{"person_name" => "James Sadler"}, &JsonTransform.Transformers.to_camel/1)

      # => %{"personName" => "James Sadler"}

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `json_transform` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:json_transform, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/json_transform](https://hexdocs.pm/json_transform).
