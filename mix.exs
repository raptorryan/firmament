defmodule Firmament.MixProject do
  @moduledoc "Defines a `Mix.Project` project."
  @moduledoc since: "0.1.0"

  use Mix.Project

  @typedoc "Represents the project configuration keyword."
  @typedoc since: "0.1.0"
  @type project_keyword() ::
          {:apps_path, Path.t()}
          | {:version, String.t()}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the project configuration."
  @typedoc since: "0.1.0"
  @type project() :: [project_keyword()]

  @doc """
  Defines the project configuration for `Firmament`.

  ## Examples

      iex> project()[:apps_path]
      "app"

      iex> project()[:version]
      "0.4.0"

  """
  @doc since: "0.1.0"
  @spec project() :: project()
  def project() do
    [
      aliases: [
        "boundary.ex_doc_groups": "cmd mix boundary.ex_doc_groups",
        "boundary.visualize": "cmd mix boundary.visualize",
        credo: ["credo --config-name default", "cmd mix credo"],
        docs: "cmd mix docs"
      ],
      apps_path: "app",
      deps: [
        {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
        {:dialyxir, "~> 1.2", only: :dev, runtime: false}
      ],
      deps_path: "dep",
      dialyzer: [ignore_warnings: ".dialyzer.exs"],
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      version: "0.4.0"
    ]
  end
end
