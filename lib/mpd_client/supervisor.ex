defmodule MpdClient.Supervisor do
  import Logger

  def start_link(_name) do
    Logger.debug "MpdClient.Supervisor start_link(_)"
    Supervisor.start_link(__MODULE__, [], name: :supervisor)  # TODO(というか調べろ): 自分自身をsupervise ?
  end

  def init(_) do
    Logger.debug "MpdClient.Supervisor init(_)"
    # routeとかを管理してるmoduleをsupervise
    children = [
      Supervisor.Spec.worker(MpdClient.Router, [name: MpdClient.Router]),
      Supervisor.Spec.worker(MpdClient.Util.Supervisor, [name: MpdClient.Util.Supervisor]),
    ]
    # TODO: one_for_oneでホントにOK ?
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end
