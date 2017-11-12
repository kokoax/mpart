defmodule MpdClient.Supervisor do
  @moduledoc """
  Add document
  """
  import Logger

  def start_link(_name) do
    Logger.debug "MpdClient.Supervisor start_link(_)"
    Supervisor.start_link(__MODULE__, [], name: :supervisor)
  end

  def init(_) do
    Logger.debug "MpdClient.Supervisor init(_)"
    # routeとかを管理してるmoduleをsupervise
    children = [
      Supervisor.Spec.worker(
        MpdClient.Router,
        [name: MpdClient.Router]
      ),
      Supervisor.Spec.worker(
        MpdClient.Util.Supervisor,
        [name: MpdClient.Util.Supervisor]
      ),
    ]
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end
