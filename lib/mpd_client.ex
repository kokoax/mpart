defmodule MpdClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  import Logger

  use Application

  def start(_type, _args) do
    Logger.debug "MpdClient.Application start(_type,_args)"
    # 一番大本のSupervisorをsupervise
    Supervisor.start_link(MpdClient.Supervisor, [], name: MpdClient.Supervisor)
  end
end
