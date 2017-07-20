defmodule JsonTransform.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.trim

  def project do
    [
      description: """
      A library for recursively transforming keys of structs before they are
      transformed into JSON or after transforming from JSON
      """,
      version: @version,
      app: :json_transform,
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:inflex, "~> 1.8.1"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE VERSION),
      maintainers: ["Alembic Pty Ltd"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/team-alembic/json_transform"}
    ]
  end
end
