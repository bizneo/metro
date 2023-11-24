defmodule Metro do
  @moduledoc """
  Documentation for `Metro`.
  """

  use Supervisor

  require Logger

  alias Metro.Instrumenters

  def start(_, opts), do: start_link(opts)

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: Metro.Supervisor)
  end

  @impl Supervisor
  def init(opts) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Metro.Plug, options: [port: 9000]}
    ]

    attach_telemetry!(opts)
    Instrumenters.Ecto.setup()
    Instrumenters.Phoenix.setup()
    Metro.Plug.setup()

    Logger.info("[Metro] Starting metrics endpoint at http://localhost:9000/metrics")

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp attach_telemetry!(opts) do
    app_name = Keyword.fetch!(opts, :app)

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [app_name, :repo, :query],
        &Instrumenters.Ecto.handle_event/4,
        nil
      )
  end
end
