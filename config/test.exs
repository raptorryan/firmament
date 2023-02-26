import Config, only: [config: 2, config: 3, import_config: 1]

import_config "prod.exs"

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
