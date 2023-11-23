defmodule Metro do
  @moduledoc """
  Documentation for `Metro`.
  """

  use Supervisor

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
    Metro.RepoInstrumenter.setup()
    Metro.Plug.setup()

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp attach_telemetry!(opts) do
    app_name = Keyword.fetch!(opts, :app)

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [app_name, :repo, :query],
        &Metro.RepoInstrumenter.handle_event/4,
        nil
      )
  end
end
