defmodule Mpdart do
  @moduledoc """
  This is root supervisor module.
  """

  import Logger

  use Application

  def start(_type, _args) do
    Logger.debug "Mpdart start(_type,_args)"

    Supervisor.start_link(Mpdart.Supervisor, [], name: Mpdart.Supervisor)
  end
end
