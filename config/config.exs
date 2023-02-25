import Config, only: [config_env: 0, import_config: 1]

for config <-
      "../app/*/config/config.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end

import_config "#{config_env()}.exs"
