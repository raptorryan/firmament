import Config, only: [config: 2, config: 3, import_config: 1]

import_config "test.exs"

config :logger, level: :debug
config :phoenix, :stacktrace_depth, 32
