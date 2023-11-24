defmodule Metro.MixProject do
  use Mix.Project

  @source_url "https://github.com/bizneo/metro"
  @version "0.1.0"

  def project do
    [
      app: :metro,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp description do
    """
    Plug and play Prometheus metrics of Erlang VM and Ecto for Elixir projects.
    """
  end

  defp package do
    [
      maintainers: ["Bizneo Solutions"],
      licenses: ["MIT"],
      source_url: @source_url,
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
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
