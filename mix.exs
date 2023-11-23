defmodule Metro.MixProject do
  use Mix.Project

  def project do
    [
      app: :metro,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Metro, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:prometheus_ex, "~> 3.1"},
      {:prometheus_plugs, "~> 1.1.1"},
      {:prometheus_ecto, "~> 1.4.3"},
      {:prometheus_phoenix, "~> 1.3.0"},
      {:plug_cowboy, "<= 3.0.0"},
      {:telemetry, "~> 0.4 or ~> 1.0"}
    ]
  end
end
