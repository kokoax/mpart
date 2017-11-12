defmodule Mpdart.Middleware.Supervisor do
  @moduledoc """
  Add document
  """
  import Logger

  alias Mpdart.Middleware.DB.CoverArtGetter
  alias Mpdart.Middleware.Mpd.Util

  def start_link(_) do
    Logger.debug fn -> "Mpdart.Middleware.Mpd.Supervisor start_link" end
    Supervisor.start_link(__MODULE__, [], name: :supervisor)
  end

  def init(_) do
    children = [
      Supervisor.Spec.worker(
        CoverArtGetter,
        [name: CoverArtGetter]
      ),
      Supervisor.Spec.worker(
        Util,
        [name: Util]
      ),
    ]
    Supervisor.Spec.supervise(children, strategy: :one_for_one)
  end
end
