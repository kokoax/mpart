defmodule MpdClient.Util.Supervisor do
  import Logger

  def start_link(_) do
    Logger.debug "MpdClient.Util.Supervisor  start_link"
    Supervisor.start_link(__MODULE__, [], name: :supervisor)  # TODO(というか調べろ): 自分自身をsupervise ?
  end

  def init(_) do
    children = [
      Supervisor.Spec.worker(MpdClient.Util.CoverArtGetter, [name: MpdClient.Util.CoverArtGetter]),
      Supervisor.Spec.worker(MpdClient.Util.Commands, [name: MpdClient.Util.Commands]),
    ]
    # TODO: one_for_oneでホントにOK ?
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end

