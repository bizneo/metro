defmodule Metro do
  @moduledoc """
  Documentation for `Metro`.
  """

  use Supervisor

  require Logger

  def start(_, opts), do: start_link(opts)

  def start_link(opts) do
    with {:ok, pid} <- Supervisor.start_link(__MODULE__, opts, name: Metro.Supervisor) do
      Logger.info("Running Metro at http://localhost:#{get_port(opts)}/metrics")
      {:ok, pid}
    end
  end

  @impl Supervisor
  def init(opts) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Metro.Router, options: [port: get_port(opts)]}
    ]

    attach_telemetry!(opts)
    Metro.EctoInstrumenter.setup()
    Metro.Plug.setup()

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

  defp get_port(opts) do
    Keyword.get(opts, :port, 9000)
  end
end
