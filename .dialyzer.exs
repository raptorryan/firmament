"app/**/.dialyzer.exs"
|> Path.wildcard(match_dot: true)
|> Stream.flat_map(&(&1 |> Code.eval_file() |> elem(0)))
|> Enum.uniq()
