defmodule JsonTransform.PlugTest do
  use ExUnit.Case
  use Plug.Test
  doctest JsonTransform.Plug

  alias JsonTransform.Plug.ResponseTransformer

  test "non json content is ignored" do
    result =
      conn("get", "/")
      |> ResponseTransformer.call(transformer: &JsonTransform.Transformers.to_camel/1)
      |> put_resp_header("content-type", "text/html")
      |> send_resp(200, "<html />")

    assert result.resp_body == "<html />"
  end

  test "json content is transformed" do
    result =
      conn("get", "/")
      |> ResponseTransformer.call(transformer: &JsonTransform.Transformers.to_camel/1)
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, "{\"some_key\": \"some value\"}")

    assert result.resp_body == "{\"someKey\":\"some value\"}"
  end

  test "json spec content is transformed" do
    result =
      conn("get", "/")
      |> ResponseTransformer.call(transformer: &JsonTransform.Transformers.to_camel/1)
      |> put_resp_header("content-type", "application/vnd.api+json")
      |> send_resp(200, "{\"some_key\": \"some value\"}")

    assert result.resp_body == "{\"someKey\":\"some value\"}"
  end
end
