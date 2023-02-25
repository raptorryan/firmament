[
  force_do_end_blocks: true,
  inputs: [
    ".{credo,dialyzer,formatter}.exs",
    "config/**/*.exs",
    "mix.{exs,lock}"
  ],
  line_length: 80,
  subdirectories: ["app/*"]
]
