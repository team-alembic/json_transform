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
        output = process(conn.resp_headers, conn.resp_body, opts[:transformer])

        conn
        |> resp(conn.status, output)
      end)
    end

    defp process([{"accept", "application/vnd.api+json"}], body, transformer) do
      # TODO how can we do this better? It seems woefully inefficient
      body
      |> IO.iodata_to_binary
      |> Poison.decode!
      |> JsonTransform.transform(transformer)
      |> Poison.encode!
    end
    defp process(_, body, _), do: body
  end
end
