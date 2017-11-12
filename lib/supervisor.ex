defmodule Mpdart.Supervisor do
  @moduledoc """
  Add document
  """
  import Logger

  def start_link(_name) do
    Logger.debug "Mpdart.Supervisor start_link(_)"
    Supervisor.start_link(__MODULE__, [], name: :supervisor)
  end

  def init(_) do
    Logger.debug "Mpdart.Supervisor init(_)"
    # routeとかを管理してるmoduleをsupervise
    children = [
      Supervisor.Spec.worker(
        Mpdart.Router,
        [name: Mpdart.Router]
      ),
      Supervisor.Spec.worker(
        Mpdart.Util.Supervisor,
        [name: Mpdart.Util.Supervisor]
      ),
    ]
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end
