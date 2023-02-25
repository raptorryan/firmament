import Config, only: [config: 2, import_config: 1]

import_config "test.exs"

config :logger, level: :debug
