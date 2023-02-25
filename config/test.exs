import Config, only: [config: 2, import_config: 1]

import_config "prod.exs"

config :logger, level: :warning
