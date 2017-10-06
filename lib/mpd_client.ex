defmodule MpdClient do
  @moduledoc false

  import Logger

  use Application

  def start(_type, _args) do
    Logger.debug "MpdClient start(_type,_args)"

    Supervisor.start_link(MpdClient.Supervisor, [], name: MpdClient.Supervisor)
  end
end
