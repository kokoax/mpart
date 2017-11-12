defmodule Mpdart.Supervisor do
  @moduledoc """
  Add document
  """
  import Logger

  alias Mpdart.Router
  alias Mpdart.Middleware.Mpd

  def start_link(_name) do
    Logger.debug fn -> "Mpdart.Supervisor start_link" end
    Supervisor.start_link(__MODULE__, [], name: :supervisor)
  end

  def init(_) do
    Logger.debug fn -> "Mpdart.Supervisor init" end
    # routeとかを管理してるmoduleをsupervise
    children = [
      Supervisor.Spec.worker(
        Router,
        [name: Router]
      ),
      Supervisor.Spec.worker(
        Mpd.Supervisor,
        [name: Mpdart.Util.Supervisor]
      ),
    ]
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end
