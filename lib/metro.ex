defmodule Metro do
  @moduledoc """
  Documentation for `Metro`.
  """

  use Supervisor

  require Logger

  def start(_, opts), do: start_link(opts)

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: Metro.Supervisor)
  end

  @impl Supervisor
  def init(opts) do
    port = Keyword.get(opts, :port, 9000)

    children = [
      {Plug.Cowboy, scheme: :http, plug: Metro.Plug, options: [port: port]}
    ]

    attach_telemetry!(opts)
    Metro.EctoInstrumenter.setup()
    Metro.Plug.setup()

    Logger.info("Running Metro at http://localhost:9000/metrics")

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp attach_telemetry!(opts) do
    app_name = Keyword.fetch!(opts, :app)

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [app_name, :repo, :query],
        &Metro.EctoInstrumenter.handle_event/4,
        nil
      )
  end
end
