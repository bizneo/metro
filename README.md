# Metro

This package provides basic Prometheus metrics of Erlang VM and Ecto for Elixir projects.

It exposes a new endpoint in a different port with the Prometheus endpoint at `/metrics`.

## Installation

The package can be installed by adding `metro` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:metro, "~> 0.1.0"},
  ]
end
```

After that, you need to start Metro within your application:

```elixir
defmodule MyApp.Application do
  def start(_type, _args) do
    children = [
      # Start metrics
      {Metro, app: :my_app, port: 9000}
    ]
  end
end
```

and metrics will be available at `http://localhost:9000/metrics` once you start
your application.
