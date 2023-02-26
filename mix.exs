defmodule Firmament.MixProject do
  @moduledoc "Defines a `Mix.Project` project."
  @moduledoc since: "0.1.0"

  use Mix.Project

  @typedoc "Represents the application restart type."
  @typedoc since: "0.5.0"
  @type restart_type() :: :load | :none | :permanent | :temporary | :transient

  @typedoc "Represents the release application list."
  @typedoc since: "0.5.0"
  @type inc_app() :: [{Application.app(), restart_type()}]

  @typedoc "Represents the configuration path."
  @typedoc since: "0.5.0"
  @type config_path() :: {:system, String.t(), Path.t()}

  @typedoc "Represents the configuration providers."
  @typedoc since: "0.5.0"
  @type config_providers() :: [{Config.Reader, [path: config_path()]}]

  @typedoc "Represents the release."
  @typedoc since: "0.5.0"
  @type release() :: Mix.Release.t()

  @typedoc "Represents the project configuration keyword."
  @typedoc since: "0.1.0"
  @type project_keyword() ::
          {:apps_path, Path.t()}
          | {:version, String.t()}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the project configuration."
  @typedoc since: "0.1.0"
  @type project() :: [project_keyword()]

  @inc_app [adam: :permanent]

  @spec config_providers(inc_app()) :: config_providers()
  defp config_providers(inc_app) when is_list(inc_app) do
    for app <- Keyword.keys(inc_app) do
      {
        Config.Reader,
        env: Mix.env(),
        path: {:system, "RELEASE_ROOT", "/app/#{app}/config/runtime.exs"}
      }
    end
  end

  @spec cp_config!(release()) :: release()
  defp cp_config!(
         %Mix.Release{config_providers: providers, path: root} = release
       ) do
    for {_provider, env: _env, path: {:system, _release, path}} <- providers do
      directory = Path.dirname(path)
      base = Path.basename(path)
      relative = Path.relative(path)

      root
      |> Path.join(directory)
      |> tap(&File.rm_rf!/1)
      |> tap(&File.mkdir_p!/1)
      |> Path.join(base)
      |> then(&File.cp!(relative, &1))
    end

    release
  end

  @doc """
  Defines the project configuration for `Firmament`.

  ## Examples

      iex> project()[:apps_path]
      "app"

      iex> project()[:version]
      "0.5.0"

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
      releases: [
        firmament: [
          applications: @inc_app,
          config_providers: config_providers(@inc_app),
          steps: [:assemble, &cp_config!/1]
        ]
      ],
      start_permanent: Mix.env() == :prod,
      version: "0.5.0"
    ]
  end
end
