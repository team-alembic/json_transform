defmodule JsonTransform.Plug do
  def noop(value), do: value

  defmodule RequestTransformer do
    import Plug.Conn

    @defaults [transformer: &JsonTransform.Plug.noop/1]

    def init(opts) do
      @defaults |> Keyword.merge(opts || [])
    end

    def call(conn, opts) do
      conn
      |> Map.put(:params, conn.params |> transform(opts[:transformer]))
    end

    defp transform(value, transformer) do
      value |> JsonTransform.transform(transformer)
    end
  end

  defmodule ResponseTransformer do
    import Plug.Conn

    @defaults [transformer: &JsonTransform.Plug.noop/1]

    def init(opts) do
      @defaults |> Keyword.merge(opts || [])
    end

    def call(conn, opts) do
      register_before_send(conn, fn(conn) ->
        # TODO how can we do this better? It seems woefully inefficient
        transformed_json =
          conn.resp_body
          |> IO.iodata_to_binary
          |> Poison.decode!
          |> transform(opts[:transformer])
          |> Poison.encode!

        conn
        |> resp(conn.status, transformed_json)
      end)
    end

    defp transform(value, transformer) do
      value |> JsonTransform.transform(transformer)
    end
  end
end
