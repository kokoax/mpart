defmodule Mpdart do
  @moduledoc """
  This is root supervisor module.
  """

  import Logger

  use Application

  def start(_type, _args) do
    Logger.debug fn -> "Mpdart start" end

    Supervisor.start_link(Mpdart.Supervisor, [], name: Mpdart.Supervisor)
  end
end
