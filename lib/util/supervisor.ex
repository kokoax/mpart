defmodule Mpdart.Util.Supervisor do
  @moduledoc """
  Add document
  """
  import Logger

  def start_link(_) do
    Logger.debug "Mpdart.Util.Supervisor  start_link"
    Supervisor.start_link(__MODULE__, [], name: :supervisor)
  end

  def init(_) do
    children = [
      Supervisor.Spec.worker(
        Mpdart.Util.CoverArtGetter,
        [name: Mpdart.Util.CoverArtGetter]
      ),
      Supervisor.Spec.worker(
        Mpdart.Util.Commands,
        [name: Mpdart.Util.Commands]
      ),
    ]
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end
